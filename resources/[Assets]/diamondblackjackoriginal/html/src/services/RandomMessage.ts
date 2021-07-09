const captions = [
    'You sure bro?',
    'Feelin\' lucky?',
    'Real slim shady?',
    'What if you have no legs?'
]

export const sendRandomCaptionForStandButton = (motivator: boolean): string => {
    let index = 0;
    if (motivator) {
        index = Math.floor(Math.random() * captions.length);
    } else {
        index = 0;
    }
    return captions[index];
}