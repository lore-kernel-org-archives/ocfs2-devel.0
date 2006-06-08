From: EKC <webmaster@generalsynthesis.com>
Date: Wed, 7 Jun 2006 18:47:13 -0600
Subject: [Ocfs2-devel] Extended Attribute Support?
In-Reply-To: <20060607164519.GM3082@ca-server1.us.oracle.com>
References: <355a4e960606070435q69e1413fga5c30869d38caf31@mail.gmail.com>
	<20060607164519.GM3082@ca-server1.us.oracle.com>
Message-ID: <355a4e960606071747n7ae0ea88u8a1d155586c85fe9@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Speaking of Lustre, how does OCFS2 compare in terms of scalability?

My understanding of OCFS2 is that it is limited to a maximum of 254
cluster nodes. However, most of the OCFS2 documentation that I've read
uses node slots per volume in the single digits. Are there any
practical limitations to using 254 node slots per volume on OCFS2, and
creating an OCFS2 cluster with 254 nodes (each node with 254 volumes
mounted on it)?

Since OCFS2 doesn't provide a unified namespace amongst volumes, I
would like to be able to mount the same volume across all of my
cluster nodes (up to 254). OCFS2 is attractive because of how clean
the code is, and its inclusion in the mainline kernel.

Thanks again


On 6/7/06, Mark Fasheh <mark.fasheh@oracle.com> wrote:
> On Wed, Jun 07, 2006 at 04:35:31AM -0700, EKC wrote:
> > Any word on when extended attribute support will be added to OCFS2?
> When we get to it ;) Seriously though, EA support is being planned for, it's
> just lower on the priority list than things like sparse file support, online
> resize, directory improvements, etc.
>
> > What are the impediments to someone implementing this?
> Not much - downloading the latest kernel code and editing fs/ocfs2/ to add
> this :) Patches are always welcome, and actually I think EA is a good
> candidate for someone who wants to contribute but doesn't yet understand the
> all the cluster stuff.
>
> As a first pass, a simple attribute block, pointed to by an __le64 in the
> dinode would work fine. More improvements and optimizations could come after
> that.
>
> > I've been watching the open source Lustre fs development, too. I
> > noticed that they have added extended attribute support. However,
> > OCFS2 is more attractive for some applications.
> Don't they get EA from ext3? Anyway, yeah Lustre does some really cool stuff
> - I think we're pretty different in the types of clusters we serve though :)
>         --Mark
>
> --
> Mark Fasheh
> Senior Software Developer, Oracle
> mark.fasheh at oracle.com
>
>
