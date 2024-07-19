const mpris = await Service.import("mpris")
const audio = await Service.import("audio")


const SinkItem = (stream) => Widget.Button({
    hexpand: true,
    on_clicked: () => audio.speaker = stream,
    child: Widget.Box({
        children: [
            Widget.Icon({
                icon: "audio-headphones-symbolic",
                tooltip_text: stream.icon_name || "",
            }),
            Widget.Label((stream.description || "").split(" ").slice(0, 4).join(" ")),
            Widget.Icon({
                icon: 'object-select-symbolic',
                hexpand: true,
                hpack: "end",
                visible: audio.speaker.bind("stream").as(s => s === stream.stream),
            }),
        ],
    }),
})

const SinkSelector = Widget.Box({     
    vertical: true,
    children: audio.bind("speakers").as(a => a.map(SinkItem)),
    //setup: self => console.log("\n\n\n" + self.visible + "\n\n\n")
}).hook(App, (self, windowName, visible) => {
    self.visible = false
}, 'window-toggled')

/*const SinkSelector = () => Widget.ListBox({
    name: "sink-selector",
    icon: "audio-headphones-symbolic",
    title: "Sink Selector",
    content: [
        Widget.Box({
            vertical: true,
            children: audio.bind("speakers").as(a => a.map(SinkItem)),
        }),
        Widget.Separator(),
    ],
})*/



/** @param {'speaker' | 'microphone'} type */
const VolumeSlider = (type = 'speaker') => Widget.Slider({
    hexpand: true,
    drawValue: false,
    onChange: ({ value, dragging }) => {
        if (dragging) {
            audio[type].volume = value
            audio[type].is_muted = false
        }
        
    },
    value: audio[type].bind('volume'),
    class_name: audio[type].bind("is_muted").as(m => m ? "muted" : ""),
})

const speakerSlider = VolumeSlider('speaker')
const micSlider = VolumeSlider('microphone')

const volumeOutput = Widget.Box({
    children: [
        speakerSlider,
        Widget.Button({
            on_primary_click: () => {
                SinkSelector.visible = !SinkSelector.visible;
            },
            child: Widget.Icon({
                icon: 'pan-end-symbolic'
            })
        })
    ]
})

/*const volumeInput = Widget.Box({
    children: [
        Widget.Slider({
            hexpand: true,
            draw_value: false,
            on_change: self => audio.microphone.volume = self.value,
            value: audio.microphone.bind('volume'),
            setup: self => self.hook(audio.microphone, () => {
                self.value = audio.microphone.volume    
            }),
        }),
        Widget.Button({
            on_primary_click: () => micList.visible = !micList.visible,
            child: Widget.Icon({
                icon: 'microphone-sensitivity-high',
            })
        })
    ]
})*/

const volumeBox = Widget.Box({
    vertical: true,
    css: 'min-width: 350px;min-height: 400px;',
    children: [
        Widget.Label({
            visible: true,
            label: 'Audio',
        }),
        volumeOutput,
        SinkSelector,
        micSlider,
    ],
})

export const quickSettings = Widget.Window({
    name: 'Quick Settings',
    anchor: ['top', 'right'],
    visible: false,
    css: 'min-width: 400px; min-height: 450px;',
    child: volumeBox,
})

export function Volume() {
    const volumeIndicator = Widget.Button({
        onClicked: () => quickSettings.visible = !quickSettings.visible,
        on_middle_click_release: () => audio.speaker.is_muted = !audio.speaker.is_muted,
        child: Widget.Icon().hook(audio.speaker, self => {
            const vol = audio.speaker.volume * 100
            const icons = {
                101: "overamplified",
                67: "high",
                34: "medium",
                1: "low",
                0: "muted",
            }
            const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
                threshold => threshold <= vol)
            self.icon = `audio-volume-${icons[icon]}-symbolic`
            self.tooltip_text = `Volume ${Math.floor(vol)}%`
        })           
    })

    return volumeIndicator 
}