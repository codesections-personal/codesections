#| Deploy the post to my Linode server, making it public
multi MAIN(Bool :d(:$deploy)!) {
    qx{ zola build;
        
      };
    say "some rsync command"
}


constant $content-dir = '/home/dsock/projects/codesections/main/content/blog/';
    
#| Fetch the post and render it locally
multi MAIN(Str $url-slug) {
    my Str $md = qx{ curl -s https://hedgedoc.codesections.com/\qq[$url-slug]/download };
    when $md.lines[0] !~~ /^'#'/ { say $md.lines[0]; note "Please set a title in the first line." and exit 1 } 

    mkdir $content-dir ~ $url-slug;
    my ($title, $body) = $md.lines[0, 1..*]».join("\n");
    spurt "$content-dir$url-slug/index.md", qq:to/§md/;
        +++
        title = "$title.subst(/^ '#'+\s* /, '')"
        date  = {DateTime.now}
        +++
        $body
        §md
    shell Q[ zola serve -i 192.168.0.235 -u 192.168.0.235 ];
}
