
breed [ robots robot ]
robots-own
[
  nbCollected
  averageSpeed
  lastStop
  localPStop
  localPRotate
  localPForward
  localIndex
]

globals
[
  backgroundColor
  obstacleColor
  borderColor
  trashColor
  robotColor
  nbExecution
  sumAverageSpeedTotal
  meanAverageSpeedTotal

  gridSize
  pForward
  pStop
  pRotate
  nbLeft
  averageSpeedTotal
]

to reset
  set nbExecution 0
  set sumAverageSpeedTotal 0
  set meanAverageSpeedTotal 0
end

to init-borders [bx by]
  ask patches with [pxcor = 0 or pxcor = bx or pycor = 0 or pycor = by]
  [
    set pcolor borderColor
  ]
end


to init-obstacles [ nb osize ]
  while [ nb > 0 ]
  [
    let x (random (gridSize - osize)) + 1
    let y (random (gridSize - osize)) + 1

    let flag true

    ask patches with [pxcor > x and pxcor < x + osize and pycor > y and pycor < y + osize and pcolor != backgroundColor]
    [
      set flag false
    ]

    if flag
    [
      ask patches with [pxcor > x and pxcor < x + osize and pycor > y and pycor < y + osize]
      [ set pcolor obstacleColor ]

      set nb nb - 1
    ]
  ]
end


to init-robot [ nb ]
  create-robots nb

  ask robots
  [
    if showPaths
    [set pen-mode "down"]
    set nbCollected 0
    set color robotColor
    set localPStop pStop
    set localPForward pForward
    set localPRotate pRotate
    set localIndex 0
    let out false
    while [ out = false ]
    [
      let x (random (gridSize + 1)) + 1
      let y (random (gridSize + 1)) + 1

      if ([pcolor] of (patch x y)) = backgroundColor
      [
        setxy x y
        set out true
      ]
    ]
  ]
end


to init-trash [ nb ]
  set nbLeft nbLeft + nb

  while [ nb > 0 ]
  [
    let x (random (gridSize + 1)) + 1
    let y (random (gridSize + 1)) + 1

    if ([pcolor] of (patch x y)) = backgroundColor
    [
      ask patch x y
      [ set pcolor trashColor ]

      set nb nb - 1
    ]
  ]
end

to init-trash-normal [ nbGroup nbTrashGroup stdDeviation ]
  set nbLeft nbLeft + (nbGroup * nbTrashGroup)

  while [ nbGroup > 0 ]
  [
    let tempNbTrashGroup nbTrashGroup
    let centerX (random (gridSize + 1)) + 1;
    let centerY (random (gridSize + 1)) + 1;

    while [ tempNbTrashGroup > 0 ]
    [
      let x (random-normal centerX stdDeviation)
      let y (random-normal centerY stdDeviation)

      if ([pcolor] of (patch x y)) = backgroundColor
      [
        ask patch x y
        [ set pcolor trashColor ]

        set tempNbTrashGroup tempNbTrashGroup - 1
      ]
    ]

    set nbGroup nbGroup - 1
  ]
end

to init

  clear-patches
  clear-turtles
  clear-all-plots
  clear-drawing
  if constantEnvironment
  [ random-seed 0 ]
  set backgroundColor white
  set obstacleColor red
  set borderColor blue
  set trashColor green
  set robotColor black

  set pStop 0.3333
  set pForward 0.3333
  set pRotate (1 - pForward - pStop)

  set nbLeft 0
  set gridSize 50

  ask patches
  [
    set pcolor backgroundColor
  ]

  init-borders 52 52

  init-obstacles 3 5

  init-robot nbRobot

  ifelse nbGroupTotal = 0
  [ init-trash nbTrashTotal ]
  [ init-trash-normal nbGroupTotal (nbTrashTotal / nbGroupTotal) standardDeviation ]
  random-seed new-seed
  reset-ticks
end


to stopOrCollect
  if pcolor = trashColor
  [
    set pcolor backgroundColor
    set nbCollected nbCollected + 1
    set nbLeft nbLeft - 1
  ]
end

to goAhead
  let nextColor [pcolor] of patch-ahead 1

  if nextColor != borderColor and nextColor != obstacleColor
  [ forward 1 ]
end

to changeDirection
  right (random 360)
end


to execute
  let index 0
  while [index < nbRuns]
  [
    init
    while [nbLeft > 0]
    [
      tick
      ask robots
      [
        ifelse strategy = "Brownian"
        [
          brownianStrategy
        ]
        [
          ifelse strategy = "Levy"
          [
            levystrategy
          ]
          [
            ifelse strategy = "Equiprobable"
            [
              equiprobableStrategy
            ]
            [
              customStrategy
            ]
          ]
        ]
        set averageSpeed ticks / (nbCollected + 1)
      ]
      set averageSpeedTotal ticks / (nbTrashTotal - nbLeft + 1)
    ]

    ; Progressive average (loose in precision, O(1) en espace et en temps)
    ;set meanAverageSpeedTotal (meanAverageSpeedTotal * nbExecution + averageSpeedTotal) / (nbExecution + 1)
    ;set nbExecution nbExecution + 1

    ; Real average (precise, O(n) en espace ; O(1) en temps)
    set sumAverageSpeedTotal sumAverageSpeedTotal + averageSpeedTotal
    set nbExecution nbExecution + 1
    set meanAverageSpeedTotal sumAverageSpeedTotal / nbExecution

    ; Display results
    if displayResults
    [ write averageSpeedTotal ]

    set index index + 1
  ]

  if displayResults
  [ print "" ]
end

to equiprobableStrategy
  let p random-float 1
  ifelse p < pStop
  [
    stopOrCollect
  ]
  [
    ifelse p < pStop + pForward
    [ goAhead ]
    [ changeDirection ]
  ]
end

to brownianStrategy
  ifelse localIndex = 0
  [
    stopOrCollect
    set localIndex 1
  ]
  [
    ifelse localIndex = 1
    [
      goAhead
      set localIndex 2
    ]
    [
      changeDirection
      set localIndex 0
    ]
  ]
end

to-report calculateLocalPStop
  report 1 - 1 / ((lastStop + 1) ^ 2)
end

to-report calculateNumberOfForward
;  let pValues [0. 0.5 0.6666666667 0.75 0.8 0.8333333333 0.8571428571 0.875 0.8888888889 0.9 0.9090909091 0.9166666667 0.9230769231 0.9285714286 0.9333333333 0.9375 0.9411764706 0.9444444444 0.9473684211 0.95 0.9523809524 0.9545454545 0.9565217391 0.9583333333 0.96 0.9615384615 0.962962963 0.9642857143 0.9655172414 0.9666666667 0.9677419355 0.96875 0.9696969697 0.9705882353 0.9714285714 0.9722222222 0.972972973 0.9736842105 0.9743589744 0.975 0.9756097561 0.9761904762 0.976744186 0.9772727273 0.9777777778 0.9782608696 0.9787234043 0.9791666667 0.9795918367 0.98 0.9803921569]
;  let nbForward 1
;  let mu 2
;  let pMax intProba nbForwardMax mu
;  let p random-float psumMax
;  let psum intProba nbForward mu
;  while [p >= psum]
;  [
;    set nbForward nbForward + 1
;    set psum pValues
;  ]
;
;  report 1 / ((lastStop + 1) ^ 1.5)

  let p random-float 1
  report exp (- ln (p) / mu)
end

;to-report intProba [t mu]
;  report 1 / ((mu - 1) * (t + 1) ^ (mu - 1)) - 1 / (mu - 1)
;end

to customStrategy
  let p random-float 1
  set localPStop calculateLocalPStop
  set pStop localPStop
  ifelse p < localPStop
  [
    stopOrCollect
    set lastStop 0
  ]
  [
    ifelse p < localPStop + (1 - localPStop) / 2
    [ goAhead ]
    [ changeDirection ]
    set lastStop lastStop + 1
  ]
end


to levyStrategy
  let p random-float 1
  ifelse localIndex < 1
  [
    set localIndex calculateNumberOfForward
    ifelse p < 0.5
    [
      changeDirection
    ]
    [
      stopOrCollect
    ]
  ]
  [
    goAhead
    set localIndex localIndex - 1
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
7
8
613
635
-1
-1
11.25
1
10
1
1
1
0
1
1
1
0
52
0
52
1
1
1
ticks
30.0

BUTTON
629
13
804
66
execute
execute
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

INPUTBOX
1340
13
1495
73
nbTrashTotal
100
1
0
Number

INPUTBOX
1688
13
1845
73
nbGroupTotal
10
1
0
Number

INPUTBOX
1515
13
1671
73
standardDeviation
3
1
0
Number

INPUTBOX
1168
13
1323
73
nbRobot
1
1
0
Number

MONITOR
1609
475
1848
532
Ticks per trashes collected
averageSpeedTotal
17
1
14

MONITOR
1030
474
1208
531
NIL
pForward
17
1
14

MONITOR
1407
474
1585
531
NIL
pStop
17
1
14

MONITOR
1217
474
1395
531
NIL
pRotate
17
1
14

MONITOR
904
473
1003
530
Trashes Left
nbLeft
17
1
14

SWITCH
984
67
1158
100
constantEnvironment
constantEnvironment
1
1
-1000

MONITOR
1543
538
1853
595
Robot Ticks per trashes collected
averageSpeedTotal * nbRobot
17
1
14

CHOOSER
983
14
1159
59
strategy
strategy
"Brownian" "Equiprobable" "Custom" "Levy"
3

SWITCH
631
205
803
238
showPaths
showPaths
0
1
-1000

MONITOR
1345
538
1534
595
NIL
meanAverageSpeedTotal
17
1
14

BUTTON
629
65
804
99
NIL
reset
NIL
1
T
OBSERVER
NIL
R
NIL
NIL
1

MONITOR
1234
538
1337
595
NIL
nbExecution
17
1
14

SLIDER
630
113
803
146
nbRuns
nbRuns
1
100
50
1
1
NIL
HORIZONTAL

INPUTBOX
1688
80
1845
140
mu
2
1
0
Number

SWITCH
630
158
803
191
displayResults
displayResults
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
