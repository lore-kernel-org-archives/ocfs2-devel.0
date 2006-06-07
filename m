From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 7 Jun 2006 09:45:19 -0700
Subject: [Ocfs2-devel] Extended Attribute Support?
In-Reply-To: <355a4e960606070435q69e1413fga5c30869d38caf31@mail.gmail.com>
References: <355a4e960606070435q69e1413fga5c30869d38caf31@mail.gmail.com>
Message-ID: <20060607164519.GM3082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 07, 2006 at 04:35:31AM -0700, EKC wrote:
> Any word on when extended attribute support will be added to OCFS2?
When we get to it ;) Seriously though, EA support is being planned for, it's
just lower on the priority list than things like sparse file support, online
resize, directory improvements, etc.

> What are the impediments to someone implementing this?
Not much - downloading the latest kernel code and editing fs/ocfs2/ to add
this :) Patches are always welcome, and actually I think EA is a good
candidate for someone who wants to contribute but doesn't yet understand the
all the cluster stuff.

As a first pass, a simple attribute block, pointed to by an __le64 in the
dinode would work fine. More improvements and optimizations could come after
that.

> I've been watching the open source Lustre fs development, too. I
> noticed that they have added extended attribute support. However,
> OCFS2 is more attractive for some applications.
Don't they get EA from ext3? Anyway, yeah Lustre does some really cool stuff
- I think we're pretty different in the types of clusters we serve though :)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
