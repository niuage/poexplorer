class SkillTree
  constructor: () ->
    @$select = $("select.keystone-select")

  setup: ->
    $("#skill-trees").on "click", ".import-keystones", (e) =>
      e.preventDefault()

      url = $(e.currentTarget).closest(".skill-tree")
        .find("input.url").val()
      return unless url

      encodedTree = url.substr(url.lastIndexOf("/")+1)
      return unless encodedTree

      @buildKeystoneIds(encodedTree)


  buildKeystoneIds: (e) ->
    data = @decode(e)
    ids = []

    for s in [6..data.length] by 2
      ids.push (255 & data.charCodeAt(s)) << 8 | 255 & data.charCodeAt(s+1)

    keystones = @intersect_safe(ids, @keystoneIds())

    $.each keystones, (i, e) =>
      @selectOptions().filter(->
        @.getAttribute("data-uid") == e+""
      ).prop("selected", true)

    @$select.change()

  keystoneIds: ->
    $.map @selectOptions(), (e, i) ->
      parseInt(e.getAttribute("data-uid"))

  selectOptions: ->
    @$cachedOptions ||= @$select.find("option")

  decode: (e) ->
    e = e.replace(/\-/g,"+").replace(/\_/g,"/")

    a = undefined
    i = undefined
    t = undefined
    s = undefined
    l = undefined
    n = undefined
    r = undefined
    o = undefined
    d = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    c = 0
    p = 0
    h = ""
    _ = []
    return e  unless e
    e += ""
    loop
      (if "string" is typeof e then (s = d.indexOf(e.charAt(c++))
      l = d.indexOf(e.charAt(c++))
      n = d.indexOf(e.charAt(c++))
      r = d.indexOf(e.charAt(c++))
      ) else (s = d.indexOf(String.fromCharCode(e[c++]))
      l = d.indexOf(String.fromCharCode(e[c++]))
      n = d.indexOf(String.fromCharCode(e[c++]))
      r = d.indexOf(String.fromCharCode(e[c++]))
      ))
      o = s << 18 | l << 12 | n << 6 | r
      a = 255 & o >> 16
      i = 255 & o >> 8
      t = 255 & o
      _[p++] = (if 64 is n then String.fromCharCode(a) else (if 64 is r then String.fromCharCode(a, i) else String.fromCharCode(a, i, t)))
      break unless c < e.length
    @data = _.join("")

  intersect_safe: (a, b) ->
    a.sort()
    b.sort()

    ai = 0
    bi = 0
    result = []
    while ai < a.length and bi < b.length
      if a[ai] < b[bi]
        ai++
      else if a[ai] > b[bi]
        bi++
      else
        result.push a[ai]
        ai++
        bi++
    result

  @setup: () ->
    new SkillTree().setup()

@App.SkillTree = SkillTree
