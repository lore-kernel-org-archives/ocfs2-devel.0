From: Jeffrey Mahoney <jeffm@suse.com>
Date: Mon, 09 Jan 2006 23:51:46 -0500
Subject: [Ocfs2-devel] [PATCH 00/11] ocfs2: implement userspace
 clustering interface
In-Reply-To: <20060110042959.GJ3313@ca-server1.us.oracle.com>
References: <20060109223942.GA8721@locomotive.unixthugs.org>
	<20060110042959.GJ3313@ca-server1.us.oracle.com>
Message-ID: <43C33D62.1000804@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> Hi Jeff,
> 	Thanks for sending all these patches out. Once patch 3 is in the
> mailman moderation queue, I'll be sure to let it through - last time was my
> fault as I accidentally deleted it along with the millions of spam messages
> that got caught in there. I'll start with some higher level commentary while
> I try to absorb the patchset :) More commentary will come later for sure.
> 
> To get the most nit-picky request out of the way, I noticed that many of the
> functions you add (including file system functions) don't have a prefix.
> It'd be nice if you could keep that consistent with the rest of the code in
> their respective files.
> 
> On to more important things:
> 
> I'm a bit worried about the new methods for querying heartbeat information,
> specifically that things are jumping from all heartbeat status being global
> (in the sense that it's collated into one giant map) to it being specific to
> a given region. Things like the dlm domain joining code have expected it to
> be global for some time now. Tcp had a similar assumption which you had to
> fix in patch #8. Of course there, it was easy to work around. I need to
> think more on this. Things might actually be ok, but it's not something I
> expected to change.

Ok, well that's easy enough to back off in dlm. If the resource name is
NULL, a global request is performed. If the requests lean more to the
global side than the specific requests, and they seem to, perhaps I
should introduce a counter for nodes in the user heartbeat code so that
a quick analysis is easier to come by.

> Is there any userspace source available that makes use of this yet? Hmm, I
> see that you sent a description of what's required from userspace. Perhaps
> that'll answer some more questions :)

Unfortunately, not yet. I've been focusing on the kernel component and
need to work with Lars Marowsky-Bree and Andrew Beekhof on integration
with the hb2 code.

The userspace requirements are kind of steep, but most of that code is
the cluster manager itself and is already written and well tested. The
OCFS2-specific stuff just needs to be able to setup/tear down resources
and then add/remove the links for node up/down events. That part of
things shouldn't be too difficult.


-Jeff

--
Jeff Mahoney
SUSE Labs
