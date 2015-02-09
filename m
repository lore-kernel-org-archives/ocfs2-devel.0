From: zren <zren@suse.com>
Date: Mon, 09 Feb 2015 11:39:32 +0800
Subject: [Ocfs2-devel] ocfs2-tools.git is moving, ocfs2 web site plans
In-Reply-To: <20150206210203.GI21790@wotan.suse.de>
References: <20150206210203.GI21790@wotan.suse.de>
Message-ID: <54D82BF4.5040408@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark and all,
I am wondering whether this plan will also cover ocfs2-test project.

I noticed that ocfs2-test on oss.oracle.com has not any update since 
2012-03-15.
However,there are two branches on github I found which have some 
updates. They are:
1. pibroch/ocfs2-test: https://github.com/pibroch/ocfs2-test and
2. goldwynr/ocfs2-test: https://github.com/goldwynr/ocfs2-test/tree/suse.

Any information about this issue is appreciated.

Thanks,
         -- zhen
On 2015?02?07? 05:02, Mark Fasheh wrote:
> Hi all,
>
> I used to have commit access to ocfs2-tools.git but legitimate
> security concerns at Oracle have no longer made that possible. Moving
> forward, I will host the official ocfs2-tools.git in my github:
>
> https://github.com/markfasheh/ocfs2-tools
>
> I started with a mirror of what's on oss.oracle.com. Both Srini and Goldwyn
> have commit access to the repo. The way we commit should not change -
> patches need to have at least one reviewed-by (as well as a sign-off). If
> anyone feels strongly that they should also have commit access, let me know.
>
> I will send a patch to update our kernel documentation regarding the
> location of ocfs2-tools.git shortly.
>
> The other issue I wanted to discuss was the 'official' ocfs2 web
> page. By 'official', I mean the page we refer users to in our kernel
> documentation. Right now it's http://oss.oracle.com/projects/ocfs2
> which is somewhat Oracle specific, but more importantly has the same
> restrictions as the git tree (I or other interested parties can no
> longer edit it).
>
> I'm looking into securing ourselves a new 'official' page, which can give a
> description of Ocfs2 and also link to any Oracle or SUSE pages, so their
> users know where to go. Again I don't envision anything at SUSE or Oracle
> has to change here, just that if someone opens up linux-2.6.git/fs/ocfs2.txt
> it points them somewhere common to all Ocfs2 development (and we can branch
> out from there). Also, in the future it would be nice if we put design docs
> on an official site.
>
> Right now I'm hoping I can get ocfs2.wiki.kernel.org going, otherwise I
> could always put it in another github project (or the ocfs2-tools project).
> If anyone has suggestions, please let me know. Also if anyone could help
> with any web/wiki for the project, also let me know. Both wiki.kernel.org
> and github wikis allow multiple collaborators.
>
> Thanks,
>      --Mark
>
> --
> Mark Fasheh
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>

-- 
Regards,
Zhen, Ren
HA team, SUSE
