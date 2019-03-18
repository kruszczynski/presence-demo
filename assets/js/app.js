// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import {Socket, Presence} from "phoenix"

let socket = new Socket("/socket", {
  params: {}
})

let channel = socket.channel("vote:lobby", {})
let presence = new Presence(channel)

const setCount = (node, count) => {
  node.querySelector('[data-count]').innerText = count
}

socket.connect()

presence.onSync(() => {
  let votes = {
    ruby: 0,
    elixir: 0,
    german: 0,
    java: 0,
  }

  presence.list((id, {metas: [first, ...rest]}) => {
    votes[first.vote] += 1
  })

  setCount(document.querySelector('[data-lang=elixir]'), votes.elixir)
  setCount(document.querySelector('[data-lang=ruby]'), votes.ruby)
  setCount(document.querySelector('[data-lang=java]'), votes.java)
  setCount(document.querySelector('[data-lang=german]'), votes.german)
})

channel.join()

document.querySelectorAll('[data-vote]').forEach((element) => {
  element.addEventListener('click', (e) => {
    e.preventDefault()
    let vote = element.dataset.vote
    channel.push('vote', {vote: vote})
  })
})
