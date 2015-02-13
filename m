From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 13 Feb 2015 14:56:59 -0800
Subject: [Ocfs2-devel] Update: Re: ocfs2-tools.git is moving,
	ocfs2 web site plans
In-Reply-To: <20150206210203.GI21790@wotan.suse.de>
References: <20150206210203.GI21790@wotan.suse.de>
Message-ID: <20150213225659.GR21790@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 06, 2015 at 01:02:03PM -0800, Mark Fasheh wrote:
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

The fine folks at kernel.org have given us a wiki:

https://ocfs2.wiki.kernel.org/

It is very bare right now, but I made sure to link to as much important
information as possible (including the oss.oracle.com page). From what I
understand, you should be able to edit it with your Linux Foundation ID. If
you don't have one, it's very simple to create:

https://identity.linuxfoundation.org/

If anyone is willing to help with this, I would appreciate it, otherwise
I'll fill things in at my own pace. In particular, I'd like to import our
old design docs from:

https://oss.oracle.com/osswiki/OCFS2.html

In general, I feel these would also be good to have on the wiki:

- some examples where Ocfs2 is used and why it's good there (web servers, virtual machines, databases)

- more information on our feature set (in particular, reflink)


I should be sending a patch to update our kernel docs with the new git /
homepage links shortly.

Thanks,
	--Mark

--
Mark Fasheh
