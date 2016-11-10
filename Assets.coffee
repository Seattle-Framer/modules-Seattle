exports.assets =
  img:
    path: "images/invalid.png"
  svg:
    circle: (s)         -> """<svg width="#{s}px" height="#{s}px" viewBox="0 0 #{s} #{s}"><circle cx="#{s/2}" cy="#{s/2}" r="#{s/2}" /></svg>"""
    rect: (w,h,x=0,y=0) -> """<svg width="#{w}px" height="#{h}px" viewBox="0 0 #{w} #{h}"><rect x="#{x}" y="#{y}" width="#{w}" height="#{h}" /></svg>"""
