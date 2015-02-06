From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 6 Feb 2015 13:02:03 -0800
Subject: [Ocfs2-devel] ocfs2-tools.git is moving, ocfs2 web site plans
Message-ID: <20150206210203.GI21790@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

I used to have commit access to ocfs2-tools.git but legitimate
security concerns at Oracle have no longer made that possible. Moving
forward, I will host the official ocfs2-tools.git in my github:

https://github.com/markfasheh/ocfs2-tools

I started with a mirror of what's on oss.oracle.com. Both Srini and Goldwyn
have commit access to the repo. The way we commit should not change -
patches need to have at least one reviewed-by (as well as a sign-off). If
anyone feels strongly that they should also have commit access, let me know.

I will send a patch to update our kernel documentation regarding the
location of ocfs2-tools.git shortly.

The other issue I wanted to discuss was the 'official' ocfs2 web
page. By 'official', I mean the page we refer users to in our kernel
documentation. Right now it's http://oss.oracle.com/projects/ocfs2
which is somewhat Oracle specific, but more importantly has the same
restrictions as the git tree (I or other interested parties can no
longer edit it).

I'm looking into securing ourselves a new 'official' page, which can give a
description of Ocfs2 and also link to any Oracle or SUSE pages, so their
users know where to go. Again I don't envision anything at SUSE or Oracle
has to change here, just that if someone opens up linux-2.6.git/fs/ocfs2.txt
it points them somewhere common to all Ocfs2 development (and we can branch
out from there). Also, in the future it would be nice if we put design docs
on an official site.

Right now I'm hoping I can get ocfs2.wiki.kernel.org going, otherwise I
could always put it in another github project (or the ocfs2-tools project).
If anyone has suggestions, please let me know. Also if anyone could help
with any web/wiki for the project, also let me know. Both wiki.kernel.org
and github wikis allow multiple collaborators.

Thanks,
    --Mark

--
Mark Fasheh
