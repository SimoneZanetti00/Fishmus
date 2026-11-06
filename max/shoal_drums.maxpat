{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 1,
            "revision": 4,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [
            80.0,
            80.0,
            580.0,
            340.0
        ],
        "openinpresentation": 1,
        "default_fontsize": 12.0,
        "gridsize": [
            15.0,
            15.0
        ],
        "boxes": [
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        10.0,
                        760.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        8.0,
                        520.0,
                        20.0
                    ],
                    "text": "SHOAL DRUMS - MPK pad bank B (notes 32-39) -> /drum/<name> <velocity>. Own patch, no PLAUD code.",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        34.0,
                        1900.0,
                        63.0
                    ],
                    "text": "1. INPUTS from Python via the PLAUD device: udpreceive 7400 -> route /drum/kick /drum/snare /drum/hihat /drum/dirty /drum/slice /drum/openhat /drum/clap /drum/perc -> s drumKick ... s drumPerc (velocity 0..1). 2. LEVEL = velocity^2 x voice gain. 3. SAMPLES: at load, thispatcher 'path' gives this patch's folder at run time; each voice loads <parent of that folder>/drums/<name>.wav with 'replace' (nothing absolute is saved; in the working copy: PLAUD_Drums_work/drums/, next to patchers/). When the file loads, the voice plays it (play~, stereo; a mono file is copied to both sides) and its status says 'sample'; otherwise it plays the synthesized fallback ('synth'). The SAMPLE MENU of each voice lists 'default' (drums/<name>.wav), 'synth' and the WAVE/AIFF files of drums/candidates/<name>/; a choice first switches to synth, then loads the file at once, and the voice switches to sample only when the file has loaded. 4. SLICE has no file: a 300 ms burst from a random position of buffer~ shoal_gran (shoal_gran.maxpat must be open). 5. OUTPUT: all voices -> master (on/off x gain, 30 ms) -> own dac~ 1 2. Turn DSP on in Max to hear it.",
                    "linecount": 4
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "patching_rect": [
                        20.0,
                        100.0,
                        60.0,
                        22.0
                    ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        20.0,
                        128.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        156.0,
                        35.0,
                        22.0
                    ],
                    "text": "path"
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        184.0,
                        75.0,
                        22.0
                    ],
                    "text": "thispatcher"
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        110.0,
                        184.0,
                        265.0,
                        22.0
                    ],
                    "text": "regexp (.*[^/])/+[^/]*[.]maxpat @tosymbol 2"
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        184.0,
                        180.0,
                        22.0
                    ],
                    "text": "regexp (.*[^/])/* @tosymbol 2"
                }
            },
            {
                "box": {
                    "id": "obj-9",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        110.0,
                        214.0,
                        190.0,
                        22.0
                    ],
                    "text": "regexp (.*)/[^/]+ @tosymbol 2"
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        320.0,
                        214.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/drums"
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 7,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        110.0,
                        244.0,
                        160.0,
                        22.0
                    ],
                    "text": "t s s s s s s s"
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        600.0,
                        100.0,
                        110.0,
                        22.0
                    ],
                    "text": "print shoal_drums"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        1700.0,
                        100.0,
                        24.0,
                        24.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        36.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1730.0,
                        102.0,
                        60.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        36.0,
                        120.0,
                        20.0
                    ],
                    "text": "on / off"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        1800.0,
                        100.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        180.0,
                        36.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-16",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1855.0,
                        100.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        236.0,
                        37.0,
                        150.0,
                        20.0
                    ],
                    "text": "master gain (0..1)"
                }
            },
            {
                "box": {
                    "id": "obj-17",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1700.0,
                        135.0,
                        60.0,
                        22.0
                    ],
                    "text": "pak 0 0."
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1700.0,
                        165.0,
                        85.0,
                        22.0
                    ],
                    "text": "expr $f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-19",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1700.0,
                        195.0,
                        60.0,
                        22.0
                    ],
                    "text": "pack f 30"
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1700.0,
                        225.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1700.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 1."
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1800.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 1."
                }
            },
            {
                "box": {
                    "id": "obj-23",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1700.0,
                        1215.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-24",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1800.0,
                        1215.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [
                        1700.0,
                        1250.0,
                        55.0,
                        22.0
                    ],
                    "text": "dac~ 1 2"
                }
            },
            {
                "box": {
                    "id": "obj-26",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        900.0,
                        100.0,
                        400.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        66.0,
                        540.0,
                        20.0
                    ],
                    "text": "voice: test, gain (0..1), status, sample (default = drums/<pad>.wav)"
                }
            },
            {
                "box": {
                    "id": "obj-27",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        274.0,
                        150.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        96.0,
                        93.0,
                        120.0,
                        20.0
                    ],
                    "text": "kick",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        300.0,
                        90.0,
                        22.0
                    ],
                    "text": "r drumKick"
                }
            },
            {
                "box": {
                    "id": "obj-29",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        130.0,
                        300.0,
                        22.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        92.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-30",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        160.0,
                        300.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.9"
                }
            },
            {
                "box": {
                    "id": "obj-31",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        130.0,
                        330.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        92.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-32",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "float"
                    ],
                    "patching_rect": [
                        20.0,
                        360.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-33",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        390.0,
                        110.0,
                        22.0
                    ],
                    "text": "expr $f1*$f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-34",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        330.0,
                        75.0,
                        22.0
                    ],
                    "text": "pack 0. 0.8"
                }
            },
            {
                "box": {
                    "id": "obj-35",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        20.0,
                        420.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-36",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        20.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-37",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        120.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 1."
                }
            },
            {
                "box": {
                    "id": "obj-38",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        190.0,
                        330.0,
                        36.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        226.0,
                        92.0,
                        70.0,
                        22.0
                    ],
                    "text": "synth"
                }
            },
            {
                "box": {
                    "id": "obj-39",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1120.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/kick.wav"
                }
            },
            {
                "box": {
                    "id": "obj-40",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1150.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-41",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "bang"
                    ],
                    "patching_rect": [
                        20.0,
                        1180.0,
                        120.0,
                        22.0
                    ],
                    "text": "buffer~ drums_kick"
                }
            },
            {
                "box": {
                    "id": "obj-42",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1210.0,
                        110.0,
                        22.0
                    ],
                    "text": "info~ drums_kick"
                }
            },
            {
                "box": {
                    "id": "obj-43",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        140.0,
                        1240.0,
                        40.0,
                        22.0
                    ],
                    "text": "== 1"
                }
            },
            {
                "box": {
                    "id": "obj-44",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        145.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-45",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        145.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-46",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        175.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-47",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        150.0,
                        1210.0,
                        70.0,
                        22.0
                    ],
                    "text": "set sample"
                }
            },
            {
                "box": {
                    "id": "obj-48",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1270.0,
                        140.0,
                        22.0
                    ],
                    "text": "kick sample loaded"
                }
            },
            {
                "box": {
                    "id": "obj-49",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1310.0,
                        190.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/candidates/kick"
                }
            },
            {
                "box": {
                    "id": "obj-50",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "bang",
                        "bang",
                        "",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        20.0,
                        1340.0,
                        80.0,
                        22.0
                    ],
                    "text": "t b b s s b"
                }
            },
            {
                "box": {
                    "id": "obj-51",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        115.0,
                        1340.0,
                        100.0,
                        22.0
                    ],
                    "text": "types WAVE AIFF"
                }
            },
            {
                "box": {
                    "id": "obj-52",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1370.0,
                        200.0,
                        22.0
                    ],
                    "text": "clear, append default, append synth"
                }
            },
            {
                "box": {
                    "id": "obj-53",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        140.0,
                        1400.0,
                        75.0,
                        22.0
                    ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-54",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        140.0,
                        1430.0,
                        80.0,
                        22.0
                    ],
                    "text": ""
                }
            },
            {
                "box": {
                    "id": "obj-55",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "int"
                    ],
                    "patching_rect": [
                        20.0,
                        1400.0,
                        50.0,
                        22.0
                    ],
                    "text": "folder"
                }
            },
            {
                "box": {
                    "id": "obj-56",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1430.0,
                        70.0,
                        22.0
                    ],
                    "text": "route clear"
                }
            },
            {
                "box": {
                    "id": "obj-57",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        100.0,
                        1460.0,
                        40.0,
                        22.0
                    ],
                    "text": "set 0"
                }
            },
            {
                "box": {
                    "id": "obj-58",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1490.0,
                        190.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        302.0,
                        92.0,
                        250.0,
                        22.0
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-59",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1520.0,
                        60.0,
                        22.0
                    ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-60",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1550.0,
                        110.0,
                        22.0
                    ],
                    "text": "sel default synth"
                }
            },
            {
                "box": {
                    "id": "obj-61",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        20.0,
                        1580.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-62",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        140.0,
                        1580.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b s b"
                }
            },
            {
                "box": {
                    "id": "obj-63",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        100.0,
                        1640.0,
                        125.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/%s"
                }
            },
            {
                "box": {
                    "id": "obj-64",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        100.0,
                        1670.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-65",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        20.0,
                        1610.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b b b"
                }
            },
            {
                "box": {
                    "id": "obj-66",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-67",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        50.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-68",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1670.0,
                        65.0,
                        22.0
                    ],
                    "text": "set synth"
                }
            },
            {
                "box": {
                    "id": "obj-69",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "start"
                }
            },
            {
                "box": {
                    "id": "obj-70",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "signal",
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        20.0,
                        520.0,
                        125.0,
                        22.0
                    ],
                    "text": "play~ drums_kick 2"
                }
            },
            {
                "box": {
                    "id": "obj-71",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        150.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "$1 2"
                }
            },
            {
                "box": {
                    "id": "obj-72",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        150.0,
                        520.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-73",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        20.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-74",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        80.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-75",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        130.0,
                        550.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 0."
                }
            },
            {
                "box": {
                    "id": "obj-76",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        620.0,
                        75.0,
                        22.0
                    ],
                    "text": "150, 45 90"
                }
            },
            {
                "box": {
                    "id": "obj-77",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        100.0,
                        620.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-78",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        20.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-79",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        20.0,
                        680.0,
                        45.0,
                        22.0
                    ],
                    "text": "cycle~"
                }
            },
            {
                "box": {
                    "id": "obj-80",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        620.0,
                        70.0,
                        22.0
                    ],
                    "text": "$1 2 0 300"
                }
            },
            {
                "box": {
                    "id": "obj-81",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        130.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-82",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        20.0,
                        710.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-83",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        20.0,
                        740.0,
                        42.0,
                        22.0
                    ],
                    "text": "tanh~"
                }
            },
            {
                "box": {
                    "id": "obj-84",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "float",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        130.0,
                        590.0,
                        50.0,
                        22.0
                    ],
                    "text": "t f b b"
                }
            },
            {
                "box": {
                    "id": "obj-85",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        230.0,
                        274.0,
                        150.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        96.0,
                        119.0,
                        120.0,
                        20.0
                    ],
                    "text": "snare",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-86",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        300.0,
                        90.0,
                        22.0
                    ],
                    "text": "r drumSnare"
                }
            },
            {
                "box": {
                    "id": "obj-87",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        340.0,
                        300.0,
                        22.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        118.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-88",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        370.0,
                        300.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.9"
                }
            },
            {
                "box": {
                    "id": "obj-89",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        340.0,
                        330.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        118.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-90",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "float"
                    ],
                    "patching_rect": [
                        230.0,
                        360.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-91",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        390.0,
                        110.0,
                        22.0
                    ],
                    "text": "expr $f1*$f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-92",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        330.0,
                        75.0,
                        22.0
                    ],
                    "text": "pack 0. 0.8"
                }
            },
            {
                "box": {
                    "id": "obj-93",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        230.0,
                        420.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-94",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        230.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-95",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        330.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 1."
                }
            },
            {
                "box": {
                    "id": "obj-96",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        400.0,
                        330.0,
                        36.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        226.0,
                        118.0,
                        70.0,
                        22.0
                    ],
                    "text": "synth"
                }
            },
            {
                "box": {
                    "id": "obj-97",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1120.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/snare.wav"
                }
            },
            {
                "box": {
                    "id": "obj-98",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1150.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-99",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "bang"
                    ],
                    "patching_rect": [
                        230.0,
                        1180.0,
                        120.0,
                        22.0
                    ],
                    "text": "buffer~ drums_snare"
                }
            },
            {
                "box": {
                    "id": "obj-100",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1210.0,
                        110.0,
                        22.0
                    ],
                    "text": "info~ drums_snare"
                }
            },
            {
                "box": {
                    "id": "obj-101",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        350.0,
                        1240.0,
                        40.0,
                        22.0
                    ],
                    "text": "== 1"
                }
            },
            {
                "box": {
                    "id": "obj-102",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        355.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-103",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        355.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-104",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        385.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-105",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        360.0,
                        1210.0,
                        70.0,
                        22.0
                    ],
                    "text": "set sample"
                }
            },
            {
                "box": {
                    "id": "obj-106",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1270.0,
                        140.0,
                        22.0
                    ],
                    "text": "snare sample loaded"
                }
            },
            {
                "box": {
                    "id": "obj-107",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1310.0,
                        190.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/candidates/snare"
                }
            },
            {
                "box": {
                    "id": "obj-108",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "bang",
                        "bang",
                        "",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        230.0,
                        1340.0,
                        80.0,
                        22.0
                    ],
                    "text": "t b b s s b"
                }
            },
            {
                "box": {
                    "id": "obj-109",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        325.0,
                        1340.0,
                        100.0,
                        22.0
                    ],
                    "text": "types WAVE AIFF"
                }
            },
            {
                "box": {
                    "id": "obj-110",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1370.0,
                        200.0,
                        22.0
                    ],
                    "text": "clear, append default, append synth"
                }
            },
            {
                "box": {
                    "id": "obj-111",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        350.0,
                        1400.0,
                        75.0,
                        22.0
                    ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-112",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        350.0,
                        1430.0,
                        80.0,
                        22.0
                    ],
                    "text": ""
                }
            },
            {
                "box": {
                    "id": "obj-113",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "int"
                    ],
                    "patching_rect": [
                        230.0,
                        1400.0,
                        50.0,
                        22.0
                    ],
                    "text": "folder"
                }
            },
            {
                "box": {
                    "id": "obj-114",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1430.0,
                        70.0,
                        22.0
                    ],
                    "text": "route clear"
                }
            },
            {
                "box": {
                    "id": "obj-115",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        310.0,
                        1460.0,
                        40.0,
                        22.0
                    ],
                    "text": "set 0"
                }
            },
            {
                "box": {
                    "id": "obj-116",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1490.0,
                        190.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        302.0,
                        118.0,
                        250.0,
                        22.0
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-117",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1520.0,
                        60.0,
                        22.0
                    ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-118",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1550.0,
                        110.0,
                        22.0
                    ],
                    "text": "sel default synth"
                }
            },
            {
                "box": {
                    "id": "obj-119",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        230.0,
                        1580.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-120",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        350.0,
                        1580.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b s b"
                }
            },
            {
                "box": {
                    "id": "obj-121",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        310.0,
                        1640.0,
                        125.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/%s"
                }
            },
            {
                "box": {
                    "id": "obj-122",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        310.0,
                        1670.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-123",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        230.0,
                        1610.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b b b"
                }
            },
            {
                "box": {
                    "id": "obj-124",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-125",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        260.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-126",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        1670.0,
                        65.0,
                        22.0
                    ],
                    "text": "set synth"
                }
            },
            {
                "box": {
                    "id": "obj-127",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        230.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "start"
                }
            },
            {
                "box": {
                    "id": "obj-128",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "signal",
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        230.0,
                        520.0,
                        125.0,
                        22.0
                    ],
                    "text": "play~ drums_snare 2"
                }
            },
            {
                "box": {
                    "id": "obj-129",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        360.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "$1 2"
                }
            },
            {
                "box": {
                    "id": "obj-130",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        360.0,
                        520.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-131",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        230.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-132",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        290.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-133",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        340.0,
                        550.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 0."
                }
            },
            {
                "box": {
                    "id": "obj-134",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        230.0,
                        620.0,
                        45.0,
                        22.0
                    ],
                    "text": "noise~"
                }
            },
            {
                "box": {
                    "id": "obj-135",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 4,
                    "outlettype": [
                        "signal",
                        "signal",
                        "signal",
                        "signal"
                    ],
                    "patching_rect": [
                        230.0,
                        650.0,
                        90.0,
                        22.0
                    ],
                    "text": "svf~ 1800 0.3"
                }
            },
            {
                "box": {
                    "id": "obj-136",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        330.0,
                        620.0,
                        70.0,
                        22.0
                    ],
                    "text": "$1 1 0 160"
                }
            },
            {
                "box": {
                    "id": "obj-137",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        330.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-138",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        230.0,
                        680.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-139",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        330.0,
                        680.0,
                        65.0,
                        22.0
                    ],
                    "text": "cycle~ 185"
                }
            },
            {
                "box": {
                    "id": "obj-140",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        330.0,
                        710.0,
                        65.0,
                        22.0
                    ],
                    "text": "$1 1 0 70"
                }
            },
            {
                "box": {
                    "id": "obj-141",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        330.0,
                        740.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-142",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        290.0,
                        770.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-143",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        290.0,
                        800.0,
                        45.0,
                        22.0
                    ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-144",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        230.0,
                        830.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 1."
                }
            },
            {
                "box": {
                    "id": "obj-145",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        400.0,
                        590.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-146",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        440.0,
                        274.0,
                        150.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        96.0,
                        145.0,
                        120.0,
                        20.0
                    ],
                    "text": "hihat",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-147",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        300.0,
                        90.0,
                        22.0
                    ],
                    "text": "r drumHihat"
                }
            },
            {
                "box": {
                    "id": "obj-148",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        550.0,
                        300.0,
                        22.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        144.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-149",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        580.0,
                        300.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.9"
                }
            },
            {
                "box": {
                    "id": "obj-150",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        550.0,
                        330.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        144.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-151",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "float"
                    ],
                    "patching_rect": [
                        440.0,
                        360.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-152",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        390.0,
                        110.0,
                        22.0
                    ],
                    "text": "expr $f1*$f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-153",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        330.0,
                        75.0,
                        22.0
                    ],
                    "text": "pack 0. 0.8"
                }
            },
            {
                "box": {
                    "id": "obj-154",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        440.0,
                        420.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-155",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        440.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-156",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        540.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 1."
                }
            },
            {
                "box": {
                    "id": "obj-157",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        610.0,
                        330.0,
                        36.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        226.0,
                        144.0,
                        70.0,
                        22.0
                    ],
                    "text": "synth"
                }
            },
            {
                "box": {
                    "id": "obj-158",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1120.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/hihat.wav"
                }
            },
            {
                "box": {
                    "id": "obj-159",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1150.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-160",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "bang"
                    ],
                    "patching_rect": [
                        440.0,
                        1180.0,
                        120.0,
                        22.0
                    ],
                    "text": "buffer~ drums_hihat"
                }
            },
            {
                "box": {
                    "id": "obj-161",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1210.0,
                        110.0,
                        22.0
                    ],
                    "text": "info~ drums_hihat"
                }
            },
            {
                "box": {
                    "id": "obj-162",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        560.0,
                        1240.0,
                        40.0,
                        22.0
                    ],
                    "text": "== 1"
                }
            },
            {
                "box": {
                    "id": "obj-163",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        565.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-164",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        565.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-165",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        595.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-166",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        570.0,
                        1210.0,
                        70.0,
                        22.0
                    ],
                    "text": "set sample"
                }
            },
            {
                "box": {
                    "id": "obj-167",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1270.0,
                        140.0,
                        22.0
                    ],
                    "text": "hihat sample loaded"
                }
            },
            {
                "box": {
                    "id": "obj-168",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1310.0,
                        190.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/candidates/hihat"
                }
            },
            {
                "box": {
                    "id": "obj-169",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "bang",
                        "bang",
                        "",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        440.0,
                        1340.0,
                        80.0,
                        22.0
                    ],
                    "text": "t b b s s b"
                }
            },
            {
                "box": {
                    "id": "obj-170",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        535.0,
                        1340.0,
                        100.0,
                        22.0
                    ],
                    "text": "types WAVE AIFF"
                }
            },
            {
                "box": {
                    "id": "obj-171",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1370.0,
                        200.0,
                        22.0
                    ],
                    "text": "clear, append default, append synth"
                }
            },
            {
                "box": {
                    "id": "obj-172",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        560.0,
                        1400.0,
                        75.0,
                        22.0
                    ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-173",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        560.0,
                        1430.0,
                        80.0,
                        22.0
                    ],
                    "text": ""
                }
            },
            {
                "box": {
                    "id": "obj-174",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "int"
                    ],
                    "patching_rect": [
                        440.0,
                        1400.0,
                        50.0,
                        22.0
                    ],
                    "text": "folder"
                }
            },
            {
                "box": {
                    "id": "obj-175",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1430.0,
                        70.0,
                        22.0
                    ],
                    "text": "route clear"
                }
            },
            {
                "box": {
                    "id": "obj-176",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        520.0,
                        1460.0,
                        40.0,
                        22.0
                    ],
                    "text": "set 0"
                }
            },
            {
                "box": {
                    "id": "obj-177",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1490.0,
                        190.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        302.0,
                        144.0,
                        250.0,
                        22.0
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-178",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1520.0,
                        60.0,
                        22.0
                    ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-179",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1550.0,
                        110.0,
                        22.0
                    ],
                    "text": "sel default synth"
                }
            },
            {
                "box": {
                    "id": "obj-180",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        440.0,
                        1580.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-181",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        560.0,
                        1580.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b s b"
                }
            },
            {
                "box": {
                    "id": "obj-182",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        520.0,
                        1640.0,
                        125.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/%s"
                }
            },
            {
                "box": {
                    "id": "obj-183",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        520.0,
                        1670.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-184",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        440.0,
                        1610.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b b b"
                }
            },
            {
                "box": {
                    "id": "obj-185",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-186",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        470.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-187",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        1670.0,
                        65.0,
                        22.0
                    ],
                    "text": "set synth"
                }
            },
            {
                "box": {
                    "id": "obj-188",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        440.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "start"
                }
            },
            {
                "box": {
                    "id": "obj-189",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "signal",
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        440.0,
                        520.0,
                        125.0,
                        22.0
                    ],
                    "text": "play~ drums_hihat 2"
                }
            },
            {
                "box": {
                    "id": "obj-190",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        570.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "$1 2"
                }
            },
            {
                "box": {
                    "id": "obj-191",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        570.0,
                        520.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-192",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        440.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-193",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        500.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-194",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        550.0,
                        550.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 0."
                }
            },
            {
                "box": {
                    "id": "obj-195",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        440.0,
                        620.0,
                        45.0,
                        22.0
                    ],
                    "text": "noise~"
                }
            },
            {
                "box": {
                    "id": "obj-196",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 4,
                    "outlettype": [
                        "signal",
                        "signal",
                        "signal",
                        "signal"
                    ],
                    "patching_rect": [
                        440.0,
                        650.0,
                        90.0,
                        22.0
                    ],
                    "text": "svf~ 8000 0.2"
                }
            },
            {
                "box": {
                    "id": "obj-197",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        540.0,
                        620.0,
                        70.0,
                        22.0
                    ],
                    "text": "$1 1 0 45"
                }
            },
            {
                "box": {
                    "id": "obj-198",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        540.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-199",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        440.0,
                        680.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-200",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        650.0,
                        274.0,
                        150.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        96.0,
                        171.0,
                        120.0,
                        20.0
                    ],
                    "text": "dirty",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-201",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        300.0,
                        90.0,
                        22.0
                    ],
                    "text": "r drumDirty"
                }
            },
            {
                "box": {
                    "id": "obj-202",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        760.0,
                        300.0,
                        22.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        170.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-203",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        790.0,
                        300.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.9"
                }
            },
            {
                "box": {
                    "id": "obj-204",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        760.0,
                        330.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        170.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-205",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "float"
                    ],
                    "patching_rect": [
                        650.0,
                        360.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-206",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        390.0,
                        110.0,
                        22.0
                    ],
                    "text": "expr $f1*$f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-207",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        330.0,
                        75.0,
                        22.0
                    ],
                    "text": "pack 0. 0.8"
                }
            },
            {
                "box": {
                    "id": "obj-208",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        650.0,
                        420.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-209",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        650.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-210",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        750.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 1."
                }
            },
            {
                "box": {
                    "id": "obj-211",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        820.0,
                        330.0,
                        36.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        226.0,
                        170.0,
                        70.0,
                        22.0
                    ],
                    "text": "synth"
                }
            },
            {
                "box": {
                    "id": "obj-212",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1120.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/dirty.wav"
                }
            },
            {
                "box": {
                    "id": "obj-213",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1150.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-214",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "bang"
                    ],
                    "patching_rect": [
                        650.0,
                        1180.0,
                        120.0,
                        22.0
                    ],
                    "text": "buffer~ drums_dirty"
                }
            },
            {
                "box": {
                    "id": "obj-215",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1210.0,
                        110.0,
                        22.0
                    ],
                    "text": "info~ drums_dirty"
                }
            },
            {
                "box": {
                    "id": "obj-216",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        770.0,
                        1240.0,
                        40.0,
                        22.0
                    ],
                    "text": "== 1"
                }
            },
            {
                "box": {
                    "id": "obj-217",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        775.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-218",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        775.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-219",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        805.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-220",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        780.0,
                        1210.0,
                        70.0,
                        22.0
                    ],
                    "text": "set sample"
                }
            },
            {
                "box": {
                    "id": "obj-221",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1270.0,
                        140.0,
                        22.0
                    ],
                    "text": "dirty sample loaded"
                }
            },
            {
                "box": {
                    "id": "obj-222",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1310.0,
                        190.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/candidates/dirty"
                }
            },
            {
                "box": {
                    "id": "obj-223",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "bang",
                        "bang",
                        "",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        650.0,
                        1340.0,
                        80.0,
                        22.0
                    ],
                    "text": "t b b s s b"
                }
            },
            {
                "box": {
                    "id": "obj-224",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        745.0,
                        1340.0,
                        100.0,
                        22.0
                    ],
                    "text": "types WAVE AIFF"
                }
            },
            {
                "box": {
                    "id": "obj-225",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1370.0,
                        200.0,
                        22.0
                    ],
                    "text": "clear, append default, append synth"
                }
            },
            {
                "box": {
                    "id": "obj-226",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        770.0,
                        1400.0,
                        75.0,
                        22.0
                    ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-227",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        770.0,
                        1430.0,
                        80.0,
                        22.0
                    ],
                    "text": ""
                }
            },
            {
                "box": {
                    "id": "obj-228",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "int"
                    ],
                    "patching_rect": [
                        650.0,
                        1400.0,
                        50.0,
                        22.0
                    ],
                    "text": "folder"
                }
            },
            {
                "box": {
                    "id": "obj-229",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1430.0,
                        70.0,
                        22.0
                    ],
                    "text": "route clear"
                }
            },
            {
                "box": {
                    "id": "obj-230",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        730.0,
                        1460.0,
                        40.0,
                        22.0
                    ],
                    "text": "set 0"
                }
            },
            {
                "box": {
                    "id": "obj-231",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1490.0,
                        190.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        302.0,
                        170.0,
                        250.0,
                        22.0
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-232",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1520.0,
                        60.0,
                        22.0
                    ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-233",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1550.0,
                        110.0,
                        22.0
                    ],
                    "text": "sel default synth"
                }
            },
            {
                "box": {
                    "id": "obj-234",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        650.0,
                        1580.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-235",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        770.0,
                        1580.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b s b"
                }
            },
            {
                "box": {
                    "id": "obj-236",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        730.0,
                        1640.0,
                        125.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/%s"
                }
            },
            {
                "box": {
                    "id": "obj-237",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        730.0,
                        1670.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-238",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        650.0,
                        1610.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b b b"
                }
            },
            {
                "box": {
                    "id": "obj-239",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-240",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        680.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-241",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        1670.0,
                        65.0,
                        22.0
                    ],
                    "text": "set synth"
                }
            },
            {
                "box": {
                    "id": "obj-242",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        650.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "start"
                }
            },
            {
                "box": {
                    "id": "obj-243",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "signal",
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        650.0,
                        520.0,
                        125.0,
                        22.0
                    ],
                    "text": "play~ drums_dirty 2"
                }
            },
            {
                "box": {
                    "id": "obj-244",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        780.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "$1 2"
                }
            },
            {
                "box": {
                    "id": "obj-245",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        780.0,
                        520.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-246",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        650.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-247",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        710.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-248",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        760.0,
                        550.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 0."
                }
            },
            {
                "box": {
                    "id": "obj-249",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        650.0,
                        620.0,
                        45.0,
                        22.0
                    ],
                    "text": "noise~"
                }
            },
            {
                "box": {
                    "id": "obj-250",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        705.0,
                        620.0,
                        60.0,
                        22.0
                    ],
                    "text": "cycle~ 90"
                }
            },
            {
                "box": {
                    "id": "obj-251",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        650.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 1."
                }
            },
            {
                "box": {
                    "id": "obj-252",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        650.0,
                        680.0,
                        95.0,
                        22.0
                    ],
                    "text": "degrade~ 0.15 4"
                }
            },
            {
                "box": {
                    "id": "obj-253",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        760.0,
                        650.0,
                        70.0,
                        22.0
                    ],
                    "text": "$1 3 0 350"
                }
            },
            {
                "box": {
                    "id": "obj-254",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        760.0,
                        680.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-255",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        650.0,
                        710.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-256",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        650.0,
                        740.0,
                        42.0,
                        22.0
                    ],
                    "text": "tanh~"
                }
            },
            {
                "box": {
                    "id": "obj-257",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        860.0,
                        274.0,
                        150.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        96.0,
                        197.0,
                        120.0,
                        20.0
                    ],
                    "text": "slice (shoal_gran)",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-258",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        860.0,
                        300.0,
                        90.0,
                        22.0
                    ],
                    "text": "r drumSlice"
                }
            },
            {
                "box": {
                    "id": "obj-259",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        970.0,
                        300.0,
                        22.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        196.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-260",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1000.0,
                        300.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.9"
                }
            },
            {
                "box": {
                    "id": "obj-261",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        970.0,
                        330.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        196.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-262",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "float"
                    ],
                    "patching_rect": [
                        860.0,
                        360.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-263",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        860.0,
                        390.0,
                        110.0,
                        22.0
                    ],
                    "text": "expr $f1*$f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-264",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        860.0,
                        330.0,
                        75.0,
                        22.0
                    ],
                    "text": "pack 0. 0.8"
                }
            },
            {
                "box": {
                    "id": "obj-265",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        860.0,
                        420.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-266",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        860.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-267",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        960.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 1."
                }
            },
            {
                "box": {
                    "id": "obj-268",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1030.0,
                        330.0,
                        36.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        226.0,
                        196.0,
                        70.0,
                        22.0
                    ],
                    "text": "synth"
                }
            },
            {
                "box": {
                    "id": "obj-269",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        860.0,
                        490.0,
                        105.0,
                        22.0
                    ],
                    "text": "info~ shoal_gran"
                }
            },
            {
                "box": {
                    "id": "obj-270",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        910.0,
                        460.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-271",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        975.0,
                        520.0,
                        50.0,
                        22.0
                    ],
                    "text": "- 300."
                }
            },
            {
                "box": {
                    "id": "obj-272",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        975.0,
                        550.0,
                        70.0,
                        22.0
                    ],
                    "text": "maximum 0."
                }
            },
            {
                "box": {
                    "id": "obj-273",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        860.0,
                        520.0,
                        80.0,
                        22.0
                    ],
                    "text": "random 1000"
                }
            },
            {
                "box": {
                    "id": "obj-274",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        860.0,
                        550.0,
                        50.0,
                        22.0
                    ],
                    "text": "/ 1000."
                }
            },
            {
                "box": {
                    "id": "obj-275",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        860.0,
                        580.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-276",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        860.0,
                        610.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-277",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        920.0,
                        640.0,
                        50.0,
                        22.0
                    ],
                    "text": "+ 300."
                }
            },
            {
                "box": {
                    "id": "obj-278",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        860.0,
                        670.0,
                        55.0,
                        22.0
                    ],
                    "text": "pack f f"
                }
            },
            {
                "box": {
                    "id": "obj-279",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        860.0,
                        700.0,
                        75.0,
                        22.0
                    ],
                    "text": "$1, $2 300"
                }
            },
            {
                "box": {
                    "id": "obj-280",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        860.0,
                        730.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-281",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "signal",
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        860.0,
                        760.0,
                        115.0,
                        22.0
                    ],
                    "text": "play~ shoal_gran 2"
                }
            },
            {
                "box": {
                    "id": "obj-282",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        970.0,
                        670.0,
                        100.0,
                        22.0
                    ],
                    "text": "$1 5 $1 220 0 75"
                }
            },
            {
                "box": {
                    "id": "obj-283",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        970.0,
                        700.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-284",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        860.0,
                        795.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-285",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        920.0,
                        795.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-286",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1070.0,
                        274.0,
                        150.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        96.0,
                        223.0,
                        120.0,
                        20.0
                    ],
                    "text": "open hat",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-287",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        300.0,
                        90.0,
                        22.0
                    ],
                    "text": "r drumOpenhat"
                }
            },
            {
                "box": {
                    "id": "obj-288",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        1180.0,
                        300.0,
                        22.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        222.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-289",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1210.0,
                        300.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.9"
                }
            },
            {
                "box": {
                    "id": "obj-290",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        1180.0,
                        330.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        222.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-291",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "float"
                    ],
                    "patching_rect": [
                        1070.0,
                        360.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-292",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        390.0,
                        110.0,
                        22.0
                    ],
                    "text": "expr $f1*$f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-293",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        330.0,
                        75.0,
                        22.0
                    ],
                    "text": "pack 0. 0.8"
                }
            },
            {
                "box": {
                    "id": "obj-294",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        1070.0,
                        420.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-295",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        1070.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-296",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        1170.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 1."
                }
            },
            {
                "box": {
                    "id": "obj-297",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1240.0,
                        330.0,
                        36.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        226.0,
                        222.0,
                        70.0,
                        22.0
                    ],
                    "text": "synth"
                }
            },
            {
                "box": {
                    "id": "obj-298",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1120.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/openhat.wav"
                }
            },
            {
                "box": {
                    "id": "obj-299",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1150.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-300",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "bang"
                    ],
                    "patching_rect": [
                        1070.0,
                        1180.0,
                        120.0,
                        22.0
                    ],
                    "text": "buffer~ drums_openhat"
                }
            },
            {
                "box": {
                    "id": "obj-301",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1210.0,
                        110.0,
                        22.0
                    ],
                    "text": "info~ drums_openhat"
                }
            },
            {
                "box": {
                    "id": "obj-302",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        1190.0,
                        1240.0,
                        40.0,
                        22.0
                    ],
                    "text": "== 1"
                }
            },
            {
                "box": {
                    "id": "obj-303",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1195.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-304",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1195.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-305",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1225.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-306",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1200.0,
                        1210.0,
                        70.0,
                        22.0
                    ],
                    "text": "set sample"
                }
            },
            {
                "box": {
                    "id": "obj-307",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1270.0,
                        140.0,
                        22.0
                    ],
                    "text": "openhat sample loaded"
                }
            },
            {
                "box": {
                    "id": "obj-308",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1310.0,
                        190.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/candidates/openhat"
                }
            },
            {
                "box": {
                    "id": "obj-309",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "bang",
                        "bang",
                        "",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        1070.0,
                        1340.0,
                        80.0,
                        22.0
                    ],
                    "text": "t b b s s b"
                }
            },
            {
                "box": {
                    "id": "obj-310",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1165.0,
                        1340.0,
                        100.0,
                        22.0
                    ],
                    "text": "types WAVE AIFF"
                }
            },
            {
                "box": {
                    "id": "obj-311",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1370.0,
                        200.0,
                        22.0
                    ],
                    "text": "clear, append default, append synth"
                }
            },
            {
                "box": {
                    "id": "obj-312",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1190.0,
                        1400.0,
                        75.0,
                        22.0
                    ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-313",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1190.0,
                        1430.0,
                        80.0,
                        22.0
                    ],
                    "text": ""
                }
            },
            {
                "box": {
                    "id": "obj-314",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "int"
                    ],
                    "patching_rect": [
                        1070.0,
                        1400.0,
                        50.0,
                        22.0
                    ],
                    "text": "folder"
                }
            },
            {
                "box": {
                    "id": "obj-315",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1430.0,
                        70.0,
                        22.0
                    ],
                    "text": "route clear"
                }
            },
            {
                "box": {
                    "id": "obj-316",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1150.0,
                        1460.0,
                        40.0,
                        22.0
                    ],
                    "text": "set 0"
                }
            },
            {
                "box": {
                    "id": "obj-317",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1490.0,
                        190.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        302.0,
                        222.0,
                        250.0,
                        22.0
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-318",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1520.0,
                        60.0,
                        22.0
                    ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-319",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1550.0,
                        110.0,
                        22.0
                    ],
                    "text": "sel default synth"
                }
            },
            {
                "box": {
                    "id": "obj-320",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1070.0,
                        1580.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-321",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        1190.0,
                        1580.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b s b"
                }
            },
            {
                "box": {
                    "id": "obj-322",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1150.0,
                        1640.0,
                        125.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/%s"
                }
            },
            {
                "box": {
                    "id": "obj-323",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1150.0,
                        1670.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-324",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1070.0,
                        1610.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b b b"
                }
            },
            {
                "box": {
                    "id": "obj-325",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-326",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1100.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-327",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        1670.0,
                        65.0,
                        22.0
                    ],
                    "text": "set synth"
                }
            },
            {
                "box": {
                    "id": "obj-328",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1070.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "start"
                }
            },
            {
                "box": {
                    "id": "obj-329",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "signal",
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1070.0,
                        520.0,
                        125.0,
                        22.0
                    ],
                    "text": "play~ drums_openhat 2"
                }
            },
            {
                "box": {
                    "id": "obj-330",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1200.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "$1 2"
                }
            },
            {
                "box": {
                    "id": "obj-331",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1200.0,
                        520.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-332",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1070.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-333",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1130.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-334",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1180.0,
                        550.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 0."
                }
            },
            {
                "box": {
                    "id": "obj-335",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1070.0,
                        620.0,
                        45.0,
                        22.0
                    ],
                    "text": "noise~"
                }
            },
            {
                "box": {
                    "id": "obj-336",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 4,
                    "outlettype": [
                        "signal",
                        "signal",
                        "signal",
                        "signal"
                    ],
                    "patching_rect": [
                        1070.0,
                        650.0,
                        90.0,
                        22.0
                    ],
                    "text": "svf~ 7000 0.2"
                }
            },
            {
                "box": {
                    "id": "obj-337",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1170.0,
                        620.0,
                        70.0,
                        22.0
                    ],
                    "text": "$1 2 0 420"
                }
            },
            {
                "box": {
                    "id": "obj-338",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1170.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-339",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1070.0,
                        680.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-340",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1280.0,
                        274.0,
                        150.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        96.0,
                        249.0,
                        120.0,
                        20.0
                    ],
                    "text": "clap",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-341",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        300.0,
                        90.0,
                        22.0
                    ],
                    "text": "r drumClap"
                }
            },
            {
                "box": {
                    "id": "obj-342",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        1390.0,
                        300.0,
                        22.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        248.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-343",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1420.0,
                        300.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.9"
                }
            },
            {
                "box": {
                    "id": "obj-344",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        1390.0,
                        330.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        248.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-345",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "float"
                    ],
                    "patching_rect": [
                        1280.0,
                        360.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-346",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        390.0,
                        110.0,
                        22.0
                    ],
                    "text": "expr $f1*$f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-347",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        330.0,
                        75.0,
                        22.0
                    ],
                    "text": "pack 0. 0.8"
                }
            },
            {
                "box": {
                    "id": "obj-348",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        1280.0,
                        420.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-349",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        1280.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-350",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        1380.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 1."
                }
            },
            {
                "box": {
                    "id": "obj-351",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1450.0,
                        330.0,
                        36.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        226.0,
                        248.0,
                        70.0,
                        22.0
                    ],
                    "text": "synth"
                }
            },
            {
                "box": {
                    "id": "obj-352",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1120.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/clap.wav"
                }
            },
            {
                "box": {
                    "id": "obj-353",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1150.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-354",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "bang"
                    ],
                    "patching_rect": [
                        1280.0,
                        1180.0,
                        120.0,
                        22.0
                    ],
                    "text": "buffer~ drums_clap"
                }
            },
            {
                "box": {
                    "id": "obj-355",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1210.0,
                        110.0,
                        22.0
                    ],
                    "text": "info~ drums_clap"
                }
            },
            {
                "box": {
                    "id": "obj-356",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        1400.0,
                        1240.0,
                        40.0,
                        22.0
                    ],
                    "text": "== 1"
                }
            },
            {
                "box": {
                    "id": "obj-357",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1405.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-358",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1405.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-359",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1435.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-360",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1410.0,
                        1210.0,
                        70.0,
                        22.0
                    ],
                    "text": "set sample"
                }
            },
            {
                "box": {
                    "id": "obj-361",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1270.0,
                        140.0,
                        22.0
                    ],
                    "text": "clap sample loaded"
                }
            },
            {
                "box": {
                    "id": "obj-362",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1310.0,
                        190.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/candidates/clap"
                }
            },
            {
                "box": {
                    "id": "obj-363",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "bang",
                        "bang",
                        "",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        1280.0,
                        1340.0,
                        80.0,
                        22.0
                    ],
                    "text": "t b b s s b"
                }
            },
            {
                "box": {
                    "id": "obj-364",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1375.0,
                        1340.0,
                        100.0,
                        22.0
                    ],
                    "text": "types WAVE AIFF"
                }
            },
            {
                "box": {
                    "id": "obj-365",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1370.0,
                        200.0,
                        22.0
                    ],
                    "text": "clear, append default, append synth"
                }
            },
            {
                "box": {
                    "id": "obj-366",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1400.0,
                        1400.0,
                        75.0,
                        22.0
                    ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-367",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1400.0,
                        1430.0,
                        80.0,
                        22.0
                    ],
                    "text": ""
                }
            },
            {
                "box": {
                    "id": "obj-368",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "int"
                    ],
                    "patching_rect": [
                        1280.0,
                        1400.0,
                        50.0,
                        22.0
                    ],
                    "text": "folder"
                }
            },
            {
                "box": {
                    "id": "obj-369",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1430.0,
                        70.0,
                        22.0
                    ],
                    "text": "route clear"
                }
            },
            {
                "box": {
                    "id": "obj-370",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1360.0,
                        1460.0,
                        40.0,
                        22.0
                    ],
                    "text": "set 0"
                }
            },
            {
                "box": {
                    "id": "obj-371",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1490.0,
                        190.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        302.0,
                        248.0,
                        250.0,
                        22.0
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-372",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1520.0,
                        60.0,
                        22.0
                    ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-373",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1550.0,
                        110.0,
                        22.0
                    ],
                    "text": "sel default synth"
                }
            },
            {
                "box": {
                    "id": "obj-374",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1280.0,
                        1580.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-375",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        1400.0,
                        1580.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b s b"
                }
            },
            {
                "box": {
                    "id": "obj-376",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1360.0,
                        1640.0,
                        125.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/%s"
                }
            },
            {
                "box": {
                    "id": "obj-377",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1360.0,
                        1670.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-378",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1280.0,
                        1610.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b b b"
                }
            },
            {
                "box": {
                    "id": "obj-379",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-380",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1310.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-381",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        1670.0,
                        65.0,
                        22.0
                    ],
                    "text": "set synth"
                }
            },
            {
                "box": {
                    "id": "obj-382",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1280.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "start"
                }
            },
            {
                "box": {
                    "id": "obj-383",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "signal",
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1280.0,
                        520.0,
                        125.0,
                        22.0
                    ],
                    "text": "play~ drums_clap 2"
                }
            },
            {
                "box": {
                    "id": "obj-384",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1410.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "$1 2"
                }
            },
            {
                "box": {
                    "id": "obj-385",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1410.0,
                        520.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-386",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1280.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-387",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1340.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-388",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1390.0,
                        550.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 0."
                }
            },
            {
                "box": {
                    "id": "obj-389",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1280.0,
                        620.0,
                        45.0,
                        22.0
                    ],
                    "text": "noise~"
                }
            },
            {
                "box": {
                    "id": "obj-390",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 4,
                    "outlettype": [
                        "signal",
                        "signal",
                        "signal",
                        "signal"
                    ],
                    "patching_rect": [
                        1280.0,
                        650.0,
                        90.0,
                        22.0
                    ],
                    "text": "svf~ 1400 0.4"
                }
            },
            {
                "box": {
                    "id": "obj-391",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1380.0,
                        590.0,
                        110.0,
                        22.0
                    ],
                    "text": "$1 1 0 9 $1 1 0 9 $1 1 0 140"
                }
            },
            {
                "box": {
                    "id": "obj-392",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1380.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-393",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1280.0,
                        680.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-394",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1490.0,
                        274.0,
                        150.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        96.0,
                        275.0,
                        120.0,
                        20.0
                    ],
                    "text": "perc",
                    "fontface": 1
                }
            },
            {
                "box": {
                    "id": "obj-395",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        300.0,
                        90.0,
                        22.0
                    ],
                    "text": "r drumPerc"
                }
            },
            {
                "box": {
                    "id": "obj-396",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        1600.0,
                        300.0,
                        22.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        10.0,
                        274.0,
                        20.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-397",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1630.0,
                        300.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.9"
                }
            },
            {
                "box": {
                    "id": "obj-398",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        1600.0,
                        330.0,
                        50.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        36.0,
                        274.0,
                        50.0,
                        22.0
                    ],
                    "minimum": 0.0,
                    "maximum": 1.0,
                    "format": 6
                }
            },
            {
                "box": {
                    "id": "obj-399",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "float"
                    ],
                    "patching_rect": [
                        1490.0,
                        360.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-400",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        390.0,
                        110.0,
                        22.0
                    ],
                    "text": "expr $f1*$f1*$f2"
                }
            },
            {
                "box": {
                    "id": "obj-401",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        330.0,
                        75.0,
                        22.0
                    ],
                    "text": "pack 0. 0.8"
                }
            },
            {
                "box": {
                    "id": "obj-402",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "float"
                    ],
                    "patching_rect": [
                        1490.0,
                        420.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f f"
                }
            },
            {
                "box": {
                    "id": "obj-403",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        1490.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 0."
                }
            },
            {
                "box": {
                    "id": "obj-404",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        1590.0,
                        450.0,
                        40.0,
                        22.0
                    ],
                    "text": "* 1."
                }
            },
            {
                "box": {
                    "id": "obj-405",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1660.0,
                        330.0,
                        36.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        226.0,
                        274.0,
                        70.0,
                        22.0
                    ],
                    "text": "synth"
                }
            },
            {
                "box": {
                    "id": "obj-406",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1120.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/perc.wav"
                }
            },
            {
                "box": {
                    "id": "obj-407",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1150.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-408",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "bang"
                    ],
                    "patching_rect": [
                        1490.0,
                        1180.0,
                        120.0,
                        22.0
                    ],
                    "text": "buffer~ drums_perc"
                }
            },
            {
                "box": {
                    "id": "obj-409",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1210.0,
                        110.0,
                        22.0
                    ],
                    "text": "info~ drums_perc"
                }
            },
            {
                "box": {
                    "id": "obj-410",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        1610.0,
                        1240.0,
                        40.0,
                        22.0
                    ],
                    "text": "== 1"
                }
            },
            {
                "box": {
                    "id": "obj-411",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1615.0,
                        1180.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-412",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1615.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-413",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1645.0,
                        1150.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-414",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1620.0,
                        1210.0,
                        70.0,
                        22.0
                    ],
                    "text": "set sample"
                }
            },
            {
                "box": {
                    "id": "obj-415",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1270.0,
                        140.0,
                        22.0
                    ],
                    "text": "perc sample loaded"
                }
            },
            {
                "box": {
                    "id": "obj-416",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1310.0,
                        190.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/candidates/perc"
                }
            },
            {
                "box": {
                    "id": "obj-417",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [
                        "bang",
                        "bang",
                        "",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        1490.0,
                        1340.0,
                        80.0,
                        22.0
                    ],
                    "text": "t b b s s b"
                }
            },
            {
                "box": {
                    "id": "obj-418",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1585.0,
                        1340.0,
                        100.0,
                        22.0
                    ],
                    "text": "types WAVE AIFF"
                }
            },
            {
                "box": {
                    "id": "obj-419",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1370.0,
                        200.0,
                        22.0
                    ],
                    "text": "clear, append default, append synth"
                }
            },
            {
                "box": {
                    "id": "obj-420",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1610.0,
                        1400.0,
                        75.0,
                        22.0
                    ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-421",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1610.0,
                        1430.0,
                        80.0,
                        22.0
                    ],
                    "text": ""
                }
            },
            {
                "box": {
                    "id": "obj-422",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "int"
                    ],
                    "patching_rect": [
                        1490.0,
                        1400.0,
                        50.0,
                        22.0
                    ],
                    "text": "folder"
                }
            },
            {
                "box": {
                    "id": "obj-423",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1430.0,
                        70.0,
                        22.0
                    ],
                    "text": "route clear"
                }
            },
            {
                "box": {
                    "id": "obj-424",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1570.0,
                        1460.0,
                        40.0,
                        22.0
                    ],
                    "text": "set 0"
                }
            },
            {
                "box": {
                    "id": "obj-425",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1490.0,
                        190.0,
                        22.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        302.0,
                        274.0,
                        250.0,
                        22.0
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-426",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1520.0,
                        60.0,
                        22.0
                    ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-427",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1550.0,
                        110.0,
                        22.0
                    ],
                    "text": "sel default synth"
                }
            },
            {
                "box": {
                    "id": "obj-428",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1490.0,
                        1580.0,
                        40.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-429",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "",
                        "bang"
                    ],
                    "patching_rect": [
                        1610.0,
                        1580.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b s b"
                }
            },
            {
                "box": {
                    "id": "obj-430",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1570.0,
                        1640.0,
                        125.0,
                        22.0
                    ],
                    "text": "sprintf symout %s/%s"
                }
            },
            {
                "box": {
                    "id": "obj-431",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1570.0,
                        1670.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend replace"
                }
            },
            {
                "box": {
                    "id": "obj-432",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        1490.0,
                        1610.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b b b"
                }
            },
            {
                "box": {
                    "id": "obj-433",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-434",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1520.0,
                        1640.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-435",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        1670.0,
                        65.0,
                        22.0
                    ],
                    "text": "set synth"
                }
            },
            {
                "box": {
                    "id": "obj-436",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "start"
                }
            },
            {
                "box": {
                    "id": "obj-437",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "signal",
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1490.0,
                        520.0,
                        125.0,
                        22.0
                    ],
                    "text": "play~ drums_perc 2"
                }
            },
            {
                "box": {
                    "id": "obj-438",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1620.0,
                        490.0,
                        40.0,
                        22.0
                    ],
                    "text": "$1 2"
                }
            },
            {
                "box": {
                    "id": "obj-439",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1620.0,
                        520.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-440",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1490.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-441",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1550.0,
                        550.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-442",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1600.0,
                        550.0,
                        40.0,
                        22.0
                    ],
                    "text": "*~ 0."
                }
            },
            {
                "box": {
                    "id": "obj-443",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1490.0,
                        620.0,
                        75.0,
                        22.0
                    ],
                    "text": "900, 650 60"
                }
            },
            {
                "box": {
                    "id": "obj-444",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1490.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-445",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1490.0,
                        680.0,
                        45.0,
                        22.0
                    ],
                    "text": "cycle~"
                }
            },
            {
                "box": {
                    "id": "obj-446",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1590.0,
                        620.0,
                        70.0,
                        22.0
                    ],
                    "text": "$1 1 0 110"
                }
            },
            {
                "box": {
                    "id": "obj-447",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        1590.0,
                        650.0,
                        40.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-448",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        1490.0,
                        710.0,
                        32.0,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-449",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "float",
                        "bang"
                    ],
                    "patching_rect": [
                        1590.0,
                        590.0,
                        40.0,
                        22.0
                    ],
                    "text": "t f b"
                }
            },
            {
                "box": {
                    "id": "obj-450",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "bang",
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        800.0,
                        128.0,
                        55.0,
                        22.0
                    ],
                    "text": "t b b b"
                }
            },
            {
                "box": {
                    "id": "obj-451",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        800.0,
                        158.0,
                        24.0,
                        22.0
                    ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-452",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        830.0,
                        158.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.8"
                }
            },
            {
                "box": {
                    "id": "obj-453",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        870.0,
                        158.0,
                        30.0,
                        22.0
                    ],
                    "text": "0.8"
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [
                        "obj-34",
                        0
                    ],
                    "source": [
                        "obj-28",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-30",
                        0
                    ],
                    "source": [
                        "obj-29",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-34",
                        0
                    ],
                    "source": [
                        "obj-30",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-34",
                        1
                    ],
                    "source": [
                        "obj-31",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-33",
                        0
                    ],
                    "source": [
                        "obj-34",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-32",
                        0
                    ],
                    "source": [
                        "obj-33",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-35",
                        0
                    ],
                    "source": [
                        "obj-32",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-37",
                        0
                    ],
                    "source": [
                        "obj-35",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-36",
                        0
                    ],
                    "source": [
                        "obj-35",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-39",
                        0
                    ],
                    "source": [
                        "obj-11",
                        6
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-40",
                        0
                    ],
                    "source": [
                        "obj-39",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-41",
                        0
                    ],
                    "source": [
                        "obj-40",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-44",
                        0
                    ],
                    "source": [
                        "obj-41",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-42",
                        0
                    ],
                    "source": [
                        "obj-44",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-47",
                        0
                    ],
                    "source": [
                        "obj-44",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-48",
                        0
                    ],
                    "source": [
                        "obj-44",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        0
                    ],
                    "source": [
                        "obj-48",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-38",
                        0
                    ],
                    "source": [
                        "obj-47",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-45",
                        0
                    ],
                    "source": [
                        "obj-44",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-46",
                        0
                    ],
                    "source": [
                        "obj-44",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-36",
                        1
                    ],
                    "source": [
                        "obj-45",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-37",
                        1
                    ],
                    "source": [
                        "obj-46",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-43",
                        0
                    ],
                    "source": [
                        "obj-42",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-49",
                        0
                    ],
                    "source": [
                        "obj-11",
                        6
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-50",
                        0
                    ],
                    "source": [
                        "obj-49",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-51",
                        0
                    ],
                    "source": [
                        "obj-50",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-55",
                        0
                    ],
                    "source": [
                        "obj-51",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-52",
                        0
                    ],
                    "source": [
                        "obj-50",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-58",
                        0
                    ],
                    "source": [
                        "obj-52",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-53",
                        0
                    ],
                    "source": [
                        "obj-50",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-54",
                        0
                    ],
                    "source": [
                        "obj-53",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-55",
                        0
                    ],
                    "source": [
                        "obj-50",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-56",
                        0
                    ],
                    "source": [
                        "obj-55",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-58",
                        0
                    ],
                    "source": [
                        "obj-56",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-57",
                        0
                    ],
                    "source": [
                        "obj-50",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-58",
                        0
                    ],
                    "source": [
                        "obj-57",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-59",
                        0
                    ],
                    "source": [
                        "obj-58",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-60",
                        0
                    ],
                    "source": [
                        "obj-59",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-61",
                        0
                    ],
                    "source": [
                        "obj-60",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-65",
                        0
                    ],
                    "source": [
                        "obj-61",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-39",
                        0
                    ],
                    "source": [
                        "obj-61",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-65",
                        0
                    ],
                    "source": [
                        "obj-60",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-62",
                        0
                    ],
                    "source": [
                        "obj-60",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-65",
                        0
                    ],
                    "source": [
                        "obj-62",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-63",
                        1
                    ],
                    "source": [
                        "obj-62",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-54",
                        0
                    ],
                    "source": [
                        "obj-62",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-63",
                        0
                    ],
                    "source": [
                        "obj-54",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-64",
                        0
                    ],
                    "source": [
                        "obj-63",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-41",
                        0
                    ],
                    "source": [
                        "obj-64",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-68",
                        0
                    ],
                    "source": [
                        "obj-65",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-67",
                        0
                    ],
                    "source": [
                        "obj-65",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-66",
                        0
                    ],
                    "source": [
                        "obj-65",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-38",
                        0
                    ],
                    "source": [
                        "obj-68",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-37",
                        1
                    ],
                    "source": [
                        "obj-67",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-36",
                        1
                    ],
                    "source": [
                        "obj-66",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-69",
                        0
                    ],
                    "source": [
                        "obj-32",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-70",
                        0
                    ],
                    "source": [
                        "obj-69",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-71",
                        0
                    ],
                    "source": [
                        "obj-36",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-72",
                        0
                    ],
                    "source": [
                        "obj-71",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-73",
                        0
                    ],
                    "source": [
                        "obj-70",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-74",
                        0
                    ],
                    "source": [
                        "obj-70",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-73",
                        1
                    ],
                    "source": [
                        "obj-72",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-74",
                        1
                    ],
                    "source": [
                        "obj-72",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-75",
                        0
                    ],
                    "source": [
                        "obj-73",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-75",
                        1
                    ],
                    "source": [
                        "obj-43",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-73",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-74",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-75",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-84",
                        0
                    ],
                    "source": [
                        "obj-37",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-77",
                        0
                    ],
                    "source": [
                        "obj-84",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-76",
                        0
                    ],
                    "source": [
                        "obj-84",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-80",
                        0
                    ],
                    "source": [
                        "obj-84",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-79",
                        1
                    ],
                    "source": [
                        "obj-77",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-78",
                        0
                    ],
                    "source": [
                        "obj-76",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-79",
                        0
                    ],
                    "source": [
                        "obj-78",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-81",
                        0
                    ],
                    "source": [
                        "obj-80",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-82",
                        0
                    ],
                    "source": [
                        "obj-79",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-82",
                        1
                    ],
                    "source": [
                        "obj-81",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-83",
                        0
                    ],
                    "source": [
                        "obj-82",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-83",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-83",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-92",
                        0
                    ],
                    "source": [
                        "obj-86",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-88",
                        0
                    ],
                    "source": [
                        "obj-87",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-92",
                        0
                    ],
                    "source": [
                        "obj-88",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-92",
                        1
                    ],
                    "source": [
                        "obj-89",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-91",
                        0
                    ],
                    "source": [
                        "obj-92",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-90",
                        0
                    ],
                    "source": [
                        "obj-91",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-93",
                        0
                    ],
                    "source": [
                        "obj-90",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-95",
                        0
                    ],
                    "source": [
                        "obj-93",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-94",
                        0
                    ],
                    "source": [
                        "obj-93",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-97",
                        0
                    ],
                    "source": [
                        "obj-11",
                        5
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-98",
                        0
                    ],
                    "source": [
                        "obj-97",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-99",
                        0
                    ],
                    "source": [
                        "obj-98",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-102",
                        0
                    ],
                    "source": [
                        "obj-99",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-100",
                        0
                    ],
                    "source": [
                        "obj-102",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-105",
                        0
                    ],
                    "source": [
                        "obj-102",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-106",
                        0
                    ],
                    "source": [
                        "obj-102",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        0
                    ],
                    "source": [
                        "obj-106",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-96",
                        0
                    ],
                    "source": [
                        "obj-105",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-103",
                        0
                    ],
                    "source": [
                        "obj-102",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-104",
                        0
                    ],
                    "source": [
                        "obj-102",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-94",
                        1
                    ],
                    "source": [
                        "obj-103",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-95",
                        1
                    ],
                    "source": [
                        "obj-104",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-101",
                        0
                    ],
                    "source": [
                        "obj-100",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-107",
                        0
                    ],
                    "source": [
                        "obj-11",
                        5
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-108",
                        0
                    ],
                    "source": [
                        "obj-107",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-109",
                        0
                    ],
                    "source": [
                        "obj-108",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-113",
                        0
                    ],
                    "source": [
                        "obj-109",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-110",
                        0
                    ],
                    "source": [
                        "obj-108",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-116",
                        0
                    ],
                    "source": [
                        "obj-110",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-111",
                        0
                    ],
                    "source": [
                        "obj-108",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-112",
                        0
                    ],
                    "source": [
                        "obj-111",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-113",
                        0
                    ],
                    "source": [
                        "obj-108",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-114",
                        0
                    ],
                    "source": [
                        "obj-113",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-116",
                        0
                    ],
                    "source": [
                        "obj-114",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-115",
                        0
                    ],
                    "source": [
                        "obj-108",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-116",
                        0
                    ],
                    "source": [
                        "obj-115",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-117",
                        0
                    ],
                    "source": [
                        "obj-116",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-118",
                        0
                    ],
                    "source": [
                        "obj-117",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-119",
                        0
                    ],
                    "source": [
                        "obj-118",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-123",
                        0
                    ],
                    "source": [
                        "obj-119",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-97",
                        0
                    ],
                    "source": [
                        "obj-119",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-123",
                        0
                    ],
                    "source": [
                        "obj-118",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-120",
                        0
                    ],
                    "source": [
                        "obj-118",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-123",
                        0
                    ],
                    "source": [
                        "obj-120",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-121",
                        1
                    ],
                    "source": [
                        "obj-120",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-112",
                        0
                    ],
                    "source": [
                        "obj-120",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-121",
                        0
                    ],
                    "source": [
                        "obj-112",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-122",
                        0
                    ],
                    "source": [
                        "obj-121",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-99",
                        0
                    ],
                    "source": [
                        "obj-122",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-126",
                        0
                    ],
                    "source": [
                        "obj-123",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-125",
                        0
                    ],
                    "source": [
                        "obj-123",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-124",
                        0
                    ],
                    "source": [
                        "obj-123",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-96",
                        0
                    ],
                    "source": [
                        "obj-126",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-95",
                        1
                    ],
                    "source": [
                        "obj-125",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-94",
                        1
                    ],
                    "source": [
                        "obj-124",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-127",
                        0
                    ],
                    "source": [
                        "obj-90",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-128",
                        0
                    ],
                    "source": [
                        "obj-127",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-129",
                        0
                    ],
                    "source": [
                        "obj-94",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-130",
                        0
                    ],
                    "source": [
                        "obj-129",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-131",
                        0
                    ],
                    "source": [
                        "obj-128",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-132",
                        0
                    ],
                    "source": [
                        "obj-128",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-131",
                        1
                    ],
                    "source": [
                        "obj-130",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-132",
                        1
                    ],
                    "source": [
                        "obj-130",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-133",
                        0
                    ],
                    "source": [
                        "obj-131",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-133",
                        1
                    ],
                    "source": [
                        "obj-101",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-131",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-132",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-133",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-145",
                        0
                    ],
                    "source": [
                        "obj-95",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-136",
                        0
                    ],
                    "source": [
                        "obj-145",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-140",
                        0
                    ],
                    "source": [
                        "obj-145",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-135",
                        0
                    ],
                    "source": [
                        "obj-134",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-138",
                        0
                    ],
                    "source": [
                        "obj-135",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-137",
                        0
                    ],
                    "source": [
                        "obj-136",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-138",
                        1
                    ],
                    "source": [
                        "obj-137",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-141",
                        0
                    ],
                    "source": [
                        "obj-140",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-142",
                        0
                    ],
                    "source": [
                        "obj-139",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-142",
                        1
                    ],
                    "source": [
                        "obj-141",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-143",
                        0
                    ],
                    "source": [
                        "obj-142",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-144",
                        0
                    ],
                    "source": [
                        "obj-138",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-144",
                        0
                    ],
                    "source": [
                        "obj-143",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-144",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-144",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-153",
                        0
                    ],
                    "source": [
                        "obj-147",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-149",
                        0
                    ],
                    "source": [
                        "obj-148",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-153",
                        0
                    ],
                    "source": [
                        "obj-149",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-153",
                        1
                    ],
                    "source": [
                        "obj-150",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-152",
                        0
                    ],
                    "source": [
                        "obj-153",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-151",
                        0
                    ],
                    "source": [
                        "obj-152",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-154",
                        0
                    ],
                    "source": [
                        "obj-151",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-156",
                        0
                    ],
                    "source": [
                        "obj-154",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-155",
                        0
                    ],
                    "source": [
                        "obj-154",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-158",
                        0
                    ],
                    "source": [
                        "obj-11",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-159",
                        0
                    ],
                    "source": [
                        "obj-158",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-160",
                        0
                    ],
                    "source": [
                        "obj-159",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-163",
                        0
                    ],
                    "source": [
                        "obj-160",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-161",
                        0
                    ],
                    "source": [
                        "obj-163",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-166",
                        0
                    ],
                    "source": [
                        "obj-163",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-167",
                        0
                    ],
                    "source": [
                        "obj-163",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        0
                    ],
                    "source": [
                        "obj-167",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-157",
                        0
                    ],
                    "source": [
                        "obj-166",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-164",
                        0
                    ],
                    "source": [
                        "obj-163",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-165",
                        0
                    ],
                    "source": [
                        "obj-163",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-155",
                        1
                    ],
                    "source": [
                        "obj-164",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-156",
                        1
                    ],
                    "source": [
                        "obj-165",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-162",
                        0
                    ],
                    "source": [
                        "obj-161",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-168",
                        0
                    ],
                    "source": [
                        "obj-11",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-169",
                        0
                    ],
                    "source": [
                        "obj-168",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-170",
                        0
                    ],
                    "source": [
                        "obj-169",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-174",
                        0
                    ],
                    "source": [
                        "obj-170",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-171",
                        0
                    ],
                    "source": [
                        "obj-169",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-177",
                        0
                    ],
                    "source": [
                        "obj-171",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-172",
                        0
                    ],
                    "source": [
                        "obj-169",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-173",
                        0
                    ],
                    "source": [
                        "obj-172",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-174",
                        0
                    ],
                    "source": [
                        "obj-169",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-175",
                        0
                    ],
                    "source": [
                        "obj-174",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-177",
                        0
                    ],
                    "source": [
                        "obj-175",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-176",
                        0
                    ],
                    "source": [
                        "obj-169",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-177",
                        0
                    ],
                    "source": [
                        "obj-176",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-178",
                        0
                    ],
                    "source": [
                        "obj-177",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-179",
                        0
                    ],
                    "source": [
                        "obj-178",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-180",
                        0
                    ],
                    "source": [
                        "obj-179",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-184",
                        0
                    ],
                    "source": [
                        "obj-180",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-158",
                        0
                    ],
                    "source": [
                        "obj-180",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-184",
                        0
                    ],
                    "source": [
                        "obj-179",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-181",
                        0
                    ],
                    "source": [
                        "obj-179",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-184",
                        0
                    ],
                    "source": [
                        "obj-181",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-182",
                        1
                    ],
                    "source": [
                        "obj-181",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-173",
                        0
                    ],
                    "source": [
                        "obj-181",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-182",
                        0
                    ],
                    "source": [
                        "obj-173",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-183",
                        0
                    ],
                    "source": [
                        "obj-182",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-160",
                        0
                    ],
                    "source": [
                        "obj-183",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-187",
                        0
                    ],
                    "source": [
                        "obj-184",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-186",
                        0
                    ],
                    "source": [
                        "obj-184",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-185",
                        0
                    ],
                    "source": [
                        "obj-184",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-157",
                        0
                    ],
                    "source": [
                        "obj-187",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-156",
                        1
                    ],
                    "source": [
                        "obj-186",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-155",
                        1
                    ],
                    "source": [
                        "obj-185",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-188",
                        0
                    ],
                    "source": [
                        "obj-151",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-189",
                        0
                    ],
                    "source": [
                        "obj-188",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-190",
                        0
                    ],
                    "source": [
                        "obj-155",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-191",
                        0
                    ],
                    "source": [
                        "obj-190",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-192",
                        0
                    ],
                    "source": [
                        "obj-189",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-193",
                        0
                    ],
                    "source": [
                        "obj-189",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-192",
                        1
                    ],
                    "source": [
                        "obj-191",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-193",
                        1
                    ],
                    "source": [
                        "obj-191",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-194",
                        0
                    ],
                    "source": [
                        "obj-192",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-194",
                        1
                    ],
                    "source": [
                        "obj-162",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-192",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-193",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-194",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-197",
                        0
                    ],
                    "source": [
                        "obj-156",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-196",
                        0
                    ],
                    "source": [
                        "obj-195",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-199",
                        0
                    ],
                    "source": [
                        "obj-196",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-198",
                        0
                    ],
                    "source": [
                        "obj-197",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-199",
                        1
                    ],
                    "source": [
                        "obj-198",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-199",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-199",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-207",
                        0
                    ],
                    "source": [
                        "obj-201",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-203",
                        0
                    ],
                    "source": [
                        "obj-202",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-207",
                        0
                    ],
                    "source": [
                        "obj-203",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-207",
                        1
                    ],
                    "source": [
                        "obj-204",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-206",
                        0
                    ],
                    "source": [
                        "obj-207",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-205",
                        0
                    ],
                    "source": [
                        "obj-206",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-208",
                        0
                    ],
                    "source": [
                        "obj-205",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-210",
                        0
                    ],
                    "source": [
                        "obj-208",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-209",
                        0
                    ],
                    "source": [
                        "obj-208",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-212",
                        0
                    ],
                    "source": [
                        "obj-11",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-213",
                        0
                    ],
                    "source": [
                        "obj-212",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-214",
                        0
                    ],
                    "source": [
                        "obj-213",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-217",
                        0
                    ],
                    "source": [
                        "obj-214",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-215",
                        0
                    ],
                    "source": [
                        "obj-217",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-220",
                        0
                    ],
                    "source": [
                        "obj-217",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-221",
                        0
                    ],
                    "source": [
                        "obj-217",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        0
                    ],
                    "source": [
                        "obj-221",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-211",
                        0
                    ],
                    "source": [
                        "obj-220",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-218",
                        0
                    ],
                    "source": [
                        "obj-217",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-219",
                        0
                    ],
                    "source": [
                        "obj-217",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-209",
                        1
                    ],
                    "source": [
                        "obj-218",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-210",
                        1
                    ],
                    "source": [
                        "obj-219",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-216",
                        0
                    ],
                    "source": [
                        "obj-215",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-222",
                        0
                    ],
                    "source": [
                        "obj-11",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-223",
                        0
                    ],
                    "source": [
                        "obj-222",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-224",
                        0
                    ],
                    "source": [
                        "obj-223",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-228",
                        0
                    ],
                    "source": [
                        "obj-224",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-225",
                        0
                    ],
                    "source": [
                        "obj-223",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-231",
                        0
                    ],
                    "source": [
                        "obj-225",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-226",
                        0
                    ],
                    "source": [
                        "obj-223",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-227",
                        0
                    ],
                    "source": [
                        "obj-226",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-228",
                        0
                    ],
                    "source": [
                        "obj-223",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-229",
                        0
                    ],
                    "source": [
                        "obj-228",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-231",
                        0
                    ],
                    "source": [
                        "obj-229",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-230",
                        0
                    ],
                    "source": [
                        "obj-223",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-231",
                        0
                    ],
                    "source": [
                        "obj-230",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-232",
                        0
                    ],
                    "source": [
                        "obj-231",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-233",
                        0
                    ],
                    "source": [
                        "obj-232",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-234",
                        0
                    ],
                    "source": [
                        "obj-233",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-238",
                        0
                    ],
                    "source": [
                        "obj-234",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-212",
                        0
                    ],
                    "source": [
                        "obj-234",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-238",
                        0
                    ],
                    "source": [
                        "obj-233",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-235",
                        0
                    ],
                    "source": [
                        "obj-233",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-238",
                        0
                    ],
                    "source": [
                        "obj-235",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-236",
                        1
                    ],
                    "source": [
                        "obj-235",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-227",
                        0
                    ],
                    "source": [
                        "obj-235",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-236",
                        0
                    ],
                    "source": [
                        "obj-227",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-237",
                        0
                    ],
                    "source": [
                        "obj-236",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-214",
                        0
                    ],
                    "source": [
                        "obj-237",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-241",
                        0
                    ],
                    "source": [
                        "obj-238",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-240",
                        0
                    ],
                    "source": [
                        "obj-238",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-239",
                        0
                    ],
                    "source": [
                        "obj-238",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-211",
                        0
                    ],
                    "source": [
                        "obj-241",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-210",
                        1
                    ],
                    "source": [
                        "obj-240",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-209",
                        1
                    ],
                    "source": [
                        "obj-239",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-242",
                        0
                    ],
                    "source": [
                        "obj-205",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-243",
                        0
                    ],
                    "source": [
                        "obj-242",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-244",
                        0
                    ],
                    "source": [
                        "obj-209",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-245",
                        0
                    ],
                    "source": [
                        "obj-244",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-246",
                        0
                    ],
                    "source": [
                        "obj-243",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-247",
                        0
                    ],
                    "source": [
                        "obj-243",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-246",
                        1
                    ],
                    "source": [
                        "obj-245",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-247",
                        1
                    ],
                    "source": [
                        "obj-245",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-248",
                        0
                    ],
                    "source": [
                        "obj-246",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-248",
                        1
                    ],
                    "source": [
                        "obj-216",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-246",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-247",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-248",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-253",
                        0
                    ],
                    "source": [
                        "obj-210",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-251",
                        0
                    ],
                    "source": [
                        "obj-249",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-251",
                        0
                    ],
                    "source": [
                        "obj-250",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-252",
                        0
                    ],
                    "source": [
                        "obj-251",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-255",
                        0
                    ],
                    "source": [
                        "obj-252",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-254",
                        0
                    ],
                    "source": [
                        "obj-253",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-255",
                        1
                    ],
                    "source": [
                        "obj-254",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-256",
                        0
                    ],
                    "source": [
                        "obj-255",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-256",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-256",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-264",
                        0
                    ],
                    "source": [
                        "obj-258",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-260",
                        0
                    ],
                    "source": [
                        "obj-259",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-264",
                        0
                    ],
                    "source": [
                        "obj-260",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-264",
                        1
                    ],
                    "source": [
                        "obj-261",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-263",
                        0
                    ],
                    "source": [
                        "obj-264",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-262",
                        0
                    ],
                    "source": [
                        "obj-263",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-265",
                        0
                    ],
                    "source": [
                        "obj-262",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-267",
                        0
                    ],
                    "source": [
                        "obj-265",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-266",
                        0
                    ],
                    "source": [
                        "obj-265",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-270",
                        0
                    ],
                    "source": [
                        "obj-262",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-269",
                        0
                    ],
                    "source": [
                        "obj-270",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-271",
                        0
                    ],
                    "source": [
                        "obj-269",
                        6
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-272",
                        0
                    ],
                    "source": [
                        "obj-271",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-275",
                        1
                    ],
                    "source": [
                        "obj-272",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-273",
                        0
                    ],
                    "source": [
                        "obj-270",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-274",
                        0
                    ],
                    "source": [
                        "obj-273",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-275",
                        0
                    ],
                    "source": [
                        "obj-274",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-276",
                        0
                    ],
                    "source": [
                        "obj-275",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-277",
                        0
                    ],
                    "source": [
                        "obj-276",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-278",
                        1
                    ],
                    "source": [
                        "obj-277",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-278",
                        0
                    ],
                    "source": [
                        "obj-276",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-279",
                        0
                    ],
                    "source": [
                        "obj-278",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-280",
                        0
                    ],
                    "source": [
                        "obj-279",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-281",
                        0
                    ],
                    "source": [
                        "obj-280",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-282",
                        0
                    ],
                    "source": [
                        "obj-267",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-283",
                        0
                    ],
                    "source": [
                        "obj-282",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-284",
                        0
                    ],
                    "source": [
                        "obj-281",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-285",
                        0
                    ],
                    "source": [
                        "obj-281",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-284",
                        1
                    ],
                    "source": [
                        "obj-283",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-285",
                        1
                    ],
                    "source": [
                        "obj-283",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-284",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-285",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-293",
                        0
                    ],
                    "source": [
                        "obj-287",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-289",
                        0
                    ],
                    "source": [
                        "obj-288",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-293",
                        0
                    ],
                    "source": [
                        "obj-289",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-293",
                        1
                    ],
                    "source": [
                        "obj-290",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-292",
                        0
                    ],
                    "source": [
                        "obj-293",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-291",
                        0
                    ],
                    "source": [
                        "obj-292",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-294",
                        0
                    ],
                    "source": [
                        "obj-291",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-296",
                        0
                    ],
                    "source": [
                        "obj-294",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-295",
                        0
                    ],
                    "source": [
                        "obj-294",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-298",
                        0
                    ],
                    "source": [
                        "obj-11",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-299",
                        0
                    ],
                    "source": [
                        "obj-298",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-300",
                        0
                    ],
                    "source": [
                        "obj-299",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-303",
                        0
                    ],
                    "source": [
                        "obj-300",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-301",
                        0
                    ],
                    "source": [
                        "obj-303",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-306",
                        0
                    ],
                    "source": [
                        "obj-303",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-307",
                        0
                    ],
                    "source": [
                        "obj-303",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        0
                    ],
                    "source": [
                        "obj-307",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-297",
                        0
                    ],
                    "source": [
                        "obj-306",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-304",
                        0
                    ],
                    "source": [
                        "obj-303",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-305",
                        0
                    ],
                    "source": [
                        "obj-303",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-295",
                        1
                    ],
                    "source": [
                        "obj-304",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-296",
                        1
                    ],
                    "source": [
                        "obj-305",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-302",
                        0
                    ],
                    "source": [
                        "obj-301",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-308",
                        0
                    ],
                    "source": [
                        "obj-11",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-309",
                        0
                    ],
                    "source": [
                        "obj-308",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-310",
                        0
                    ],
                    "source": [
                        "obj-309",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-314",
                        0
                    ],
                    "source": [
                        "obj-310",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-311",
                        0
                    ],
                    "source": [
                        "obj-309",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-317",
                        0
                    ],
                    "source": [
                        "obj-311",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-312",
                        0
                    ],
                    "source": [
                        "obj-309",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-313",
                        0
                    ],
                    "source": [
                        "obj-312",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-314",
                        0
                    ],
                    "source": [
                        "obj-309",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-315",
                        0
                    ],
                    "source": [
                        "obj-314",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-317",
                        0
                    ],
                    "source": [
                        "obj-315",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-316",
                        0
                    ],
                    "source": [
                        "obj-309",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-317",
                        0
                    ],
                    "source": [
                        "obj-316",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-318",
                        0
                    ],
                    "source": [
                        "obj-317",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-319",
                        0
                    ],
                    "source": [
                        "obj-318",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-320",
                        0
                    ],
                    "source": [
                        "obj-319",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-324",
                        0
                    ],
                    "source": [
                        "obj-320",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-298",
                        0
                    ],
                    "source": [
                        "obj-320",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-324",
                        0
                    ],
                    "source": [
                        "obj-319",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-321",
                        0
                    ],
                    "source": [
                        "obj-319",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-324",
                        0
                    ],
                    "source": [
                        "obj-321",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-322",
                        1
                    ],
                    "source": [
                        "obj-321",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-313",
                        0
                    ],
                    "source": [
                        "obj-321",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-322",
                        0
                    ],
                    "source": [
                        "obj-313",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-323",
                        0
                    ],
                    "source": [
                        "obj-322",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-300",
                        0
                    ],
                    "source": [
                        "obj-323",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-327",
                        0
                    ],
                    "source": [
                        "obj-324",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-326",
                        0
                    ],
                    "source": [
                        "obj-324",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-325",
                        0
                    ],
                    "source": [
                        "obj-324",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-297",
                        0
                    ],
                    "source": [
                        "obj-327",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-296",
                        1
                    ],
                    "source": [
                        "obj-326",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-295",
                        1
                    ],
                    "source": [
                        "obj-325",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-328",
                        0
                    ],
                    "source": [
                        "obj-291",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-329",
                        0
                    ],
                    "source": [
                        "obj-328",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-330",
                        0
                    ],
                    "source": [
                        "obj-295",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-331",
                        0
                    ],
                    "source": [
                        "obj-330",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-332",
                        0
                    ],
                    "source": [
                        "obj-329",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-333",
                        0
                    ],
                    "source": [
                        "obj-329",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-332",
                        1
                    ],
                    "source": [
                        "obj-331",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-333",
                        1
                    ],
                    "source": [
                        "obj-331",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-334",
                        0
                    ],
                    "source": [
                        "obj-332",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-334",
                        1
                    ],
                    "source": [
                        "obj-302",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-332",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-333",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-334",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-337",
                        0
                    ],
                    "source": [
                        "obj-296",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-336",
                        0
                    ],
                    "source": [
                        "obj-335",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-339",
                        0
                    ],
                    "source": [
                        "obj-336",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-338",
                        0
                    ],
                    "source": [
                        "obj-337",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-339",
                        1
                    ],
                    "source": [
                        "obj-338",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-339",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-339",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-347",
                        0
                    ],
                    "source": [
                        "obj-341",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-343",
                        0
                    ],
                    "source": [
                        "obj-342",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-347",
                        0
                    ],
                    "source": [
                        "obj-343",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-347",
                        1
                    ],
                    "source": [
                        "obj-344",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-346",
                        0
                    ],
                    "source": [
                        "obj-347",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-345",
                        0
                    ],
                    "source": [
                        "obj-346",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-348",
                        0
                    ],
                    "source": [
                        "obj-345",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-350",
                        0
                    ],
                    "source": [
                        "obj-348",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-349",
                        0
                    ],
                    "source": [
                        "obj-348",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-352",
                        0
                    ],
                    "source": [
                        "obj-11",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-353",
                        0
                    ],
                    "source": [
                        "obj-352",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-354",
                        0
                    ],
                    "source": [
                        "obj-353",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-357",
                        0
                    ],
                    "source": [
                        "obj-354",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-355",
                        0
                    ],
                    "source": [
                        "obj-357",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-360",
                        0
                    ],
                    "source": [
                        "obj-357",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-361",
                        0
                    ],
                    "source": [
                        "obj-357",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        0
                    ],
                    "source": [
                        "obj-361",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-351",
                        0
                    ],
                    "source": [
                        "obj-360",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-358",
                        0
                    ],
                    "source": [
                        "obj-357",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-359",
                        0
                    ],
                    "source": [
                        "obj-357",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-349",
                        1
                    ],
                    "source": [
                        "obj-358",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-350",
                        1
                    ],
                    "source": [
                        "obj-359",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-356",
                        0
                    ],
                    "source": [
                        "obj-355",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-362",
                        0
                    ],
                    "source": [
                        "obj-11",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-363",
                        0
                    ],
                    "source": [
                        "obj-362",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-364",
                        0
                    ],
                    "source": [
                        "obj-363",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-368",
                        0
                    ],
                    "source": [
                        "obj-364",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-365",
                        0
                    ],
                    "source": [
                        "obj-363",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-371",
                        0
                    ],
                    "source": [
                        "obj-365",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-366",
                        0
                    ],
                    "source": [
                        "obj-363",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-367",
                        0
                    ],
                    "source": [
                        "obj-366",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-368",
                        0
                    ],
                    "source": [
                        "obj-363",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-369",
                        0
                    ],
                    "source": [
                        "obj-368",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-371",
                        0
                    ],
                    "source": [
                        "obj-369",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-370",
                        0
                    ],
                    "source": [
                        "obj-363",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-371",
                        0
                    ],
                    "source": [
                        "obj-370",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-372",
                        0
                    ],
                    "source": [
                        "obj-371",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-373",
                        0
                    ],
                    "source": [
                        "obj-372",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-374",
                        0
                    ],
                    "source": [
                        "obj-373",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-378",
                        0
                    ],
                    "source": [
                        "obj-374",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-352",
                        0
                    ],
                    "source": [
                        "obj-374",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-378",
                        0
                    ],
                    "source": [
                        "obj-373",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-375",
                        0
                    ],
                    "source": [
                        "obj-373",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-378",
                        0
                    ],
                    "source": [
                        "obj-375",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-376",
                        1
                    ],
                    "source": [
                        "obj-375",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-367",
                        0
                    ],
                    "source": [
                        "obj-375",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-376",
                        0
                    ],
                    "source": [
                        "obj-367",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-377",
                        0
                    ],
                    "source": [
                        "obj-376",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-354",
                        0
                    ],
                    "source": [
                        "obj-377",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-381",
                        0
                    ],
                    "source": [
                        "obj-378",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-380",
                        0
                    ],
                    "source": [
                        "obj-378",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-379",
                        0
                    ],
                    "source": [
                        "obj-378",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-351",
                        0
                    ],
                    "source": [
                        "obj-381",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-350",
                        1
                    ],
                    "source": [
                        "obj-380",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-349",
                        1
                    ],
                    "source": [
                        "obj-379",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-382",
                        0
                    ],
                    "source": [
                        "obj-345",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-383",
                        0
                    ],
                    "source": [
                        "obj-382",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-384",
                        0
                    ],
                    "source": [
                        "obj-349",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-385",
                        0
                    ],
                    "source": [
                        "obj-384",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-386",
                        0
                    ],
                    "source": [
                        "obj-383",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-387",
                        0
                    ],
                    "source": [
                        "obj-383",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-386",
                        1
                    ],
                    "source": [
                        "obj-385",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-387",
                        1
                    ],
                    "source": [
                        "obj-385",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-388",
                        0
                    ],
                    "source": [
                        "obj-386",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-388",
                        1
                    ],
                    "source": [
                        "obj-356",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-386",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-387",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-388",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-391",
                        0
                    ],
                    "source": [
                        "obj-350",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-390",
                        0
                    ],
                    "source": [
                        "obj-389",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-393",
                        0
                    ],
                    "source": [
                        "obj-390",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-392",
                        0
                    ],
                    "source": [
                        "obj-391",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-393",
                        1
                    ],
                    "source": [
                        "obj-392",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-393",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-393",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-401",
                        0
                    ],
                    "source": [
                        "obj-395",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-397",
                        0
                    ],
                    "source": [
                        "obj-396",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-401",
                        0
                    ],
                    "source": [
                        "obj-397",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-401",
                        1
                    ],
                    "source": [
                        "obj-398",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-400",
                        0
                    ],
                    "source": [
                        "obj-401",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-399",
                        0
                    ],
                    "source": [
                        "obj-400",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-402",
                        0
                    ],
                    "source": [
                        "obj-399",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-404",
                        0
                    ],
                    "source": [
                        "obj-402",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-403",
                        0
                    ],
                    "source": [
                        "obj-402",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-406",
                        0
                    ],
                    "source": [
                        "obj-11",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-407",
                        0
                    ],
                    "source": [
                        "obj-406",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-408",
                        0
                    ],
                    "source": [
                        "obj-407",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-411",
                        0
                    ],
                    "source": [
                        "obj-408",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-409",
                        0
                    ],
                    "source": [
                        "obj-411",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-414",
                        0
                    ],
                    "source": [
                        "obj-411",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-415",
                        0
                    ],
                    "source": [
                        "obj-411",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        0
                    ],
                    "source": [
                        "obj-415",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-405",
                        0
                    ],
                    "source": [
                        "obj-414",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-412",
                        0
                    ],
                    "source": [
                        "obj-411",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-413",
                        0
                    ],
                    "source": [
                        "obj-411",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-403",
                        1
                    ],
                    "source": [
                        "obj-412",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-404",
                        1
                    ],
                    "source": [
                        "obj-413",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-410",
                        0
                    ],
                    "source": [
                        "obj-409",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-416",
                        0
                    ],
                    "source": [
                        "obj-11",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-417",
                        0
                    ],
                    "source": [
                        "obj-416",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-418",
                        0
                    ],
                    "source": [
                        "obj-417",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-422",
                        0
                    ],
                    "source": [
                        "obj-418",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-419",
                        0
                    ],
                    "source": [
                        "obj-417",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-425",
                        0
                    ],
                    "source": [
                        "obj-419",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-420",
                        0
                    ],
                    "source": [
                        "obj-417",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-421",
                        0
                    ],
                    "source": [
                        "obj-420",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-422",
                        0
                    ],
                    "source": [
                        "obj-417",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-423",
                        0
                    ],
                    "source": [
                        "obj-422",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-425",
                        0
                    ],
                    "source": [
                        "obj-423",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-424",
                        0
                    ],
                    "source": [
                        "obj-417",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-425",
                        0
                    ],
                    "source": [
                        "obj-424",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-426",
                        0
                    ],
                    "source": [
                        "obj-425",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-427",
                        0
                    ],
                    "source": [
                        "obj-426",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-428",
                        0
                    ],
                    "source": [
                        "obj-427",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-432",
                        0
                    ],
                    "source": [
                        "obj-428",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-406",
                        0
                    ],
                    "source": [
                        "obj-428",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-432",
                        0
                    ],
                    "source": [
                        "obj-427",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-429",
                        0
                    ],
                    "source": [
                        "obj-427",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-432",
                        0
                    ],
                    "source": [
                        "obj-429",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-430",
                        1
                    ],
                    "source": [
                        "obj-429",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-421",
                        0
                    ],
                    "source": [
                        "obj-429",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-430",
                        0
                    ],
                    "source": [
                        "obj-421",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-431",
                        0
                    ],
                    "source": [
                        "obj-430",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-408",
                        0
                    ],
                    "source": [
                        "obj-431",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-435",
                        0
                    ],
                    "source": [
                        "obj-432",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-434",
                        0
                    ],
                    "source": [
                        "obj-432",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-433",
                        0
                    ],
                    "source": [
                        "obj-432",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-405",
                        0
                    ],
                    "source": [
                        "obj-435",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-404",
                        1
                    ],
                    "source": [
                        "obj-434",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-403",
                        1
                    ],
                    "source": [
                        "obj-433",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-436",
                        0
                    ],
                    "source": [
                        "obj-399",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-437",
                        0
                    ],
                    "source": [
                        "obj-436",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-438",
                        0
                    ],
                    "source": [
                        "obj-403",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-439",
                        0
                    ],
                    "source": [
                        "obj-438",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-440",
                        0
                    ],
                    "source": [
                        "obj-437",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-441",
                        0
                    ],
                    "source": [
                        "obj-437",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-440",
                        1
                    ],
                    "source": [
                        "obj-439",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-441",
                        1
                    ],
                    "source": [
                        "obj-439",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-442",
                        0
                    ],
                    "source": [
                        "obj-440",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-442",
                        1
                    ],
                    "source": [
                        "obj-410",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-440",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-441",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-442",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-449",
                        0
                    ],
                    "source": [
                        "obj-404",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-443",
                        0
                    ],
                    "source": [
                        "obj-449",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-446",
                        0
                    ],
                    "source": [
                        "obj-449",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-444",
                        0
                    ],
                    "source": [
                        "obj-443",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-445",
                        0
                    ],
                    "source": [
                        "obj-444",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-448",
                        0
                    ],
                    "source": [
                        "obj-445",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-447",
                        0
                    ],
                    "source": [
                        "obj-446",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-448",
                        1
                    ],
                    "source": [
                        "obj-447",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "source": [
                        "obj-448",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-448",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-23",
                        0
                    ],
                    "source": [
                        "obj-21",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-24",
                        0
                    ],
                    "source": [
                        "obj-22",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-23",
                        1
                    ],
                    "source": [
                        "obj-20",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-24",
                        1
                    ],
                    "source": [
                        "obj-20",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-25",
                        0
                    ],
                    "source": [
                        "obj-23",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-25",
                        1
                    ],
                    "source": [
                        "obj-24",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        0
                    ],
                    "source": [
                        "obj-13",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "source": [
                        "obj-15",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-18",
                        0
                    ],
                    "source": [
                        "obj-17",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-19",
                        0
                    ],
                    "source": [
                        "obj-18",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-20",
                        0
                    ],
                    "source": [
                        "obj-19",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-4",
                        0
                    ],
                    "source": [
                        "obj-3",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-5",
                        0
                    ],
                    "source": [
                        "obj-4",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-6",
                        0
                    ],
                    "source": [
                        "obj-5",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-7",
                        0
                    ],
                    "source": [
                        "obj-6",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-9",
                        0
                    ],
                    "source": [
                        "obj-7",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-8",
                        0
                    ],
                    "source": [
                        "obj-7",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-9",
                        0
                    ],
                    "source": [
                        "obj-8",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-10",
                        0
                    ],
                    "source": [
                        "obj-9",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-11",
                        0
                    ],
                    "source": [
                        "obj-10",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-450",
                        0
                    ],
                    "source": [
                        "obj-4",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-453",
                        0
                    ],
                    "source": [
                        "obj-450",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-452",
                        0
                    ],
                    "source": [
                        "obj-450",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-451",
                        0
                    ],
                    "source": [
                        "obj-450",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-13",
                        0
                    ],
                    "source": [
                        "obj-451",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-15",
                        0
                    ],
                    "source": [
                        "obj-452",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-31",
                        0
                    ],
                    "source": [
                        "obj-453",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-89",
                        0
                    ],
                    "source": [
                        "obj-453",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-150",
                        0
                    ],
                    "source": [
                        "obj-453",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-204",
                        0
                    ],
                    "source": [
                        "obj-453",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-261",
                        0
                    ],
                    "source": [
                        "obj-453",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-290",
                        0
                    ],
                    "source": [
                        "obj-453",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-344",
                        0
                    ],
                    "source": [
                        "obj-453",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-398",
                        0
                    ],
                    "source": [
                        "obj-453",
                        0
                    ]
                }
            }
        ]
    }
}
