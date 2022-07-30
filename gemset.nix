{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l29n9n38c9lpy5smh26r7fy7jp2bpjqlzhxgsr79cv7xpwlrbhs";
      type = "gem";
    };
    version = "6.0.3.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "022r3m9wdxljpbya69y2i3h9g3dhhfaqzidf95m6qjzms792jvgp";
      type = "gem";
    };
    version = "2.8.0";
  };
  builder = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  byebug = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      type = "gem";
    };
    version = "11.1.3";
  };
  coderay = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  colorize = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "133rqj85n400qk6g3dhf2bmfws34mak1wqihvh3bgy9jhajw580b";
      type = "gem";
    };
    version = "0.8.1";
  };
  concurrent-ruby = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094387x4yasb797mv07cs3g6f08y56virc2rjcpb1k79rzaj3nhl";
      type = "gem";
    };
    version = "1.1.6";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  docile = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qrwiyagxzl8zlx3dafb0ay8l14ib7imb2rsmx70i5cp420v8gif";
      type = "gem";
    };
    version = "1.3.2";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hprpff5px594czkajb1r8a7rnsibl6wygmfwdfv98kqn0ab9r3m";
      type = "gem";
    };
    version = "5.2.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13aghksmni2sl15y7wfpx6k5l3lfd8j9gdyqi6cbw6jgc7bqyyn2";
      type = "gem";
    };
    version = "0.17.3";
  };
  ffi = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10lfhahnnc91v63xpvk65apn61pib086zha3z5sp1xk9acfx12h4";
      type = "gem";
    };
    version = "1.12.2";
  };
  formatador = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gc26phrwlmlqrmz4bagq1wd5b7g64avpx0ghxr9xdxcvmlii0l0";
      type = "gem";
    };
    version = "0.2.5";
  };
  git = {
    dependencies = ["rchardet"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wd0rvz6cybqm9svcx427hgpcz804am64s0sxxrh72i9m16vm5by";
      type = "gem";
    };
    version = "1.11.0";
  };
  github_api = {
    dependencies = ["addressable" "descendants_tracker" "faraday" "hashie" "oauth2"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04x8mlvinl17wfw6r71c9jbh7g78ziiwvsqv20ylyjzybr7x0w6s";
      type = "gem";
    };
    version = "0.18.2";
  };
  guard = {
    dependencies = ["formatador" "listen" "lumberjack" "nenv" "notiffany" "pry" "shellany" "thor"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fwgvkmrg97xfswwgfrfcl1nc937yxwazfvpmf8vxj7cvnx7mfki";
      type = "gem";
    };
    version = "2.16.2";
  };
  guard-compat = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj6sr1k8w59mmi27rsii0v8xyy2rnsi09nqvwpgj1q10yq1mlis";
      type = "gem";
    };
    version = "1.2.1";
  };
  guard-rspec = {
    dependencies = ["guard" "guard-compat" "rspec"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jkm5xp90gm4c5s51pmf92i9hc10gslwwic6mvk72g0yplya0yx4";
      type = "gem";
    };
    version = "4.7.3";
  };
  hashie = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13bdzfp25c8k51ayzxqkbzag3wj5gc1jd8h7d985nsq6pn57g5xh";
      type = "gem";
    };
    version = "3.6.0";
  };
  highline = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jwrd1l4mxz06iyx6053lr6hz2zy7ah2k3ranfzisvych5q19kwm";
      type = "gem";
    };
    version = "1.8.2";
  };
  juwelier = {
    dependencies = ["builder" "git" "github_api" "highline" "kamelcase" "nokogiri" "psych" "rake" "rdoc" "semver2"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nm73lzrmck5qr429d1xk0g04k798p9ix2myj9znlrjxgxiqzhcw";
      type = "gem";
    };
    version = "2.4.9";
  };
  jwt = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01zg1vp3lyl3flyjdkrcc93ghf833qgfgh2p1biqfhkzz11r129c";
      type = "gem";
    };
    version = "2.2.1";
  };
  kamelcase = {
    dependencies = ["semver2"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05h857affpvgb638vq2lf9lc9x3pfy2w3wnzis7bwzzpcvjbw46i";
      type = "gem";
    };
    version = "0.0.2";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w923wmdi3gyiky0asqdw5dnh3gcjs2xyn82ajvjfjwh6sn0clgi";
      type = "gem";
    };
    version = "3.2.1";
  };
  lumberjack = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m9ajfrs5ys3dp2glwbmyzfpd7qyz7dz49gz78is1yra0jawkm6d";
      type = "gem";
    };
    version = "1.2.4";
  };
  method_source = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  mini_portile2 = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rapl1sfmfi3bfr68da4ca16yhc0pp93vjwkj7y3rdqrzy3b41hy";
      type = "gem";
    };
    version = "2.8.0";
  };
  minitest = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bz9nsznxgaf06cx3b5z71glgl0hdw469gqx3w7bqijgrb55p5g";
      type = "gem";
    };
    version = "5.14.1";
  };
  multi_json = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xy54mjf7xg41l8qrg1bqri75agdqmxap9z466fjismc1rn2jwfr";
      type = "gem";
    };
    version = "1.14.1";
  };
  multi_xml = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
      type = "gem";
    };
    version = "0.6.0";
  };
  multipart-post = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  nenv = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r97jzknll9bhd8yyg2bngnnkj8rjhal667n7d32h8h7ny7nvpnr";
      type = "gem";
    };
    version = "0.3.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11w59ga9324yx6339dgsflz3dsqq2mky1qqdwcg6wi5s1bf2yldi";
      type = "gem";
    };
    version = "1.13.6";
  };
  notiffany = {
    dependencies = ["nenv" "shellany"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f47h3bmg1apr4x51szqfv3rh2vq58z3grh4w02cp3bzbdh6jxnk";
      type = "gem";
    };
    version = "0.1.3";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bhakjh30vi8scqwnhd1c9qkac9r8hh2lr0dbs5ynwmrc5djxknm";
      type = "gem";
    };
    version = "1.4.4";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iyw4q4an2wmk8v5rn2ghfy2jaz9vmw2nk8415nnpx2s866934qk";
      type = "gem";
    };
    version = "0.13.1";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "096y5vmzpyy4x9h4ky4cs4y7d19vdq9vbwwrqafbh5gagzwhifiv";
      type = "gem";
    };
    version = "3.9.0";
  };
  psych = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09jv2lbpv4p4zfh77a3q0a8xl9ady96iq4rmqrnzsdn69f6wyn58";
      type = "gem";
    };
    version = "3.1.0";
  };
  public_suffix = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f3knlwfwm05sfbaihrxm4g772b79032q14c16q4b38z8bi63qcb";
      type = "gem";
    };
    version = "4.0.7";
  };
  racc = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0la56m0z26j3mfn1a9lf2l03qx1xifanndf9p3vx1azf6sqy7v9d";
      type = "gem";
    };
    version = "1.6.0";
  };
  rack = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0axc6w0rs4yj0pksfll1hjgw1k6a5q0xi2lckh91knfb72v348pa";
      type = "gem";
    };
    version = "2.2.4";
  };
  rake = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w6qza25bq1s825faaglkx1k6d59aiyjjk3yw3ip5sb463mhhai9";
      type = "gem";
    };
    version = "13.0.1";
  };
  rb-fsevent = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k9bsj7ni0g2fd7scyyy1sk9dy2pg9akniahab0iznvjmhn54h87";
      type = "gem";
    };
    version = "0.10.4";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      type = "gem";
    };
    version = "0.10.1";
  };
  rchardet = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1isj1b3ywgg2m1vdlnr41lpvpm3dbyarf1lla4dfibfmad9csfk9";
      type = "gem";
    };
    version = "1.8.0";
  };
  rdoc = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19h5g3g7k7wggy9amfx8b3m09ss7wrakbrva2xnda9sw4chagx6y";
      type = "gem";
    };
    version = "6.3.2";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hzsig4pi9ybr0xl5540m1swiyxa74c8h09225y5sdh2rjkkg84h";
      type = "gem";
    };
    version = "3.9.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xndkv5cz763wh30x7hdqw6k7zs8xfh0f86amra9agwn44pcqs0y";
      type = "gem";
    };
    version = "3.9.2";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bxkv25qmy39jqrdx35bfgw00g24qkssail9jlljm7hywbqvr9bb";
      type = "gem";
    };
    version = "3.9.2";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19vmdqym1v2g1zbdnq37zwmyj87y9yc9ijwc8js55igvbb9hx0mr";
      type = "gem";
    };
    version = "3.9.1";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dandh2fy1dfkjk8jf9v4azbbma6968bhh06hddv0yqqm8108jir";
      type = "gem";
    };
    version = "3.9.3";
  };
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0590m2pr9i209pp5z4mx0nb1961ishdiqb28995hw1nln1d1b5ji";
      type = "gem";
    };
    version = "2.3.0";
  };
  semver2 = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7w95kckdz00pi3yrvl6ymbnl5dvxcmfb4kkkp888jcq4fawdvg";
      type = "gem";
    };
    version = "3.4.2";
  };
  shellany = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ryyzrj1kxmnpdzhlv4ys3dnl2r5r3d2rs2jwzbnd1v96a8pl4hf";
      type = "gem";
    };
    version = "0.0.1";
  };
  simplecov = {
    dependencies = ["docile" "simplecov-html"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ycx5q699ycbjhp28sjbkrd62vwxlrb7fh4v2m7sjsp2qhi6cf6r";
      type = "gem";
    };
    version = "0.18.5";
  };
  simplecov-html = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v7b4mf7njw8kv4ghl4q7mwz3q0flbld7v8blp4m4m3n3aq11bn9";
      type = "gem";
    };
    version = "0.12.2";
  };
  thor = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xbhkmyhlxwzshaqa7swy2bx6vd64mm0wrr8g3jywvxy7hg0cwkm";
      type = "gem";
    };
    version = "1.0.1";
  };
  thread_safe = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rw89y3zj0wcybcyiazgcprg6hi42k8ipp1n2lbl95z1dmpgmly6";
      type = "gem";
    };
    version = "1.2.10";
  };
  yard = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "126m49mvh4lbvlvrprq7xj2vjixbq3xqr8dwr089vadvs0rkn4rd";
      type = "gem";
    };
    version = "0.9.25";
  };
  zeitwerk = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1akpm3pwvyiack2zk6giv9yn3cqb8pw6g40p4394pdc3xmy3s4k0";
      type = "gem";
    };
    version = "2.3.0";
  };
}
