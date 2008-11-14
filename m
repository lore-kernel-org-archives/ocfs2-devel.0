From: Andrew Beekhof <beekhof@gmail.com>
Date: Fri, 14 Nov 2008 22:11:00 +0100
Subject: [Ocfs2-devel] [Cluster-devel] [RFC] Splitting cluster.git into
	separate projects/trees
In-Reply-To: <20081114173743.GC18678@ca-server1.us.oracle.com>
References: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
	<20081114172530.GB4054@redhat.com>
	<20081114173743.GC18678@ca-server1.us.oracle.com>
Message-ID: <26ef5e70811141311u54f5c2d6j873e5fd3977336ea@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 14, 2008 at 18:37, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Fri, Nov 14, 2008 at 11:25:30AM -0600, David Teigland wrote:
>> On Fri, Nov 14, 2008 at 10:18:13AM +0100, Fabio M. Di Nitto wrote:
>> > At this point we haven't really settled how many (sub) project will be
>> > created out of this split. This will come once we agree how to split.
>>
>> I like the third option as long as the number of new git trees doesn't
>> explode (obviously no one wants 10 new git trees.)  Not to get ahead of
>> you, but for my own curiosity I looked at what minimum number of git trees
>> I'd have to start juggling... it's not too bad, but more than this might
>> get out of hand.
>
>        Obviously I like the third option, as I proposed it :-)  But I
> think Dave's really nailed how to split it out.  Originally, I expected
> that his fence.git, fence-agents.git, cman.git, and rgmanager.git would
> stay together as one tree, and that gfs and its utilities would also be
> one tree.

I'd have thought fence.git and fence-agents.git in one and cman.git
and rgmanager.git in another.
But I may be missing some of the interdependencies.

> Looking at it, though, I think he's right we split them out.
> That's a result from our plan at the summit to start converging fence
> agents and then eventually move fencing up the stack.

I think we can do that and have them stay together - for instance
we're thinking of putting the resource agents and the lrmd which
drives them together in a repo - but I don't care that much either
way.
