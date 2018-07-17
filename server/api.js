require('../../../Library/Caches/typescript/2.9/node_modules/@types/isomorphic-fetch')
const map = require('../../../Library/Caches/typescript/2.9/node_modules/@types/lodash/map')
const shuffle = require('../../../Library/Caches/typescript/2.9/node_modules/@types/lodash/shuffle')

async function get(type) {
    const rottentomatoesResponse = await fetch(`https://www.rottentomatoes.com/api/private/v2.0/browse?sortBy=popularity&type=${type}`)
    const json = await rottentomatoesResponse.json()
    const titles = json.results.map(element => { return { title: element.title.split(':')[0] }})
    return await Promise.all(titles.map(title => getImageFrom(title)))
}

async function getImageFrom({ title }) {
    const tvmazeResponse = await fetch(`http://api.tvmaze.com/singlesearch/shows?q=${title}`)
    const json = await tvmazeResponse.json()
    return {
        img: json.image,
        title
    }
}

module.exports = {
    get
}