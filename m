From: David Teigland <teigland@redhat.com>
Date: Fri, 14 Nov 2008 15:57:18 -0600
Subject: [Ocfs2-devel] [Cluster-devel] [RFC] Splitting cluster.git into
	separate projects/trees
In-Reply-To: <26ef5e70811141311u54f5c2d6j873e5fd3977336ea@mail.gmail.com>
References: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
	<20081114172530.GB4054@redhat.com>
	<20081114173743.GC18678@ca-server1.us.oracle.com>
	<26ef5e70811141311u54f5c2d6j873e5fd3977336ea@mail.gmail.com>
Message-ID: <20081114215718.GA7394@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 14, 2008 at 10:11:00PM +0100, Andrew Beekhof wrote:
> I'd have thought fence.git and fence-agents.git in one and cman.git
> and rgmanager.git in another.
> But I may be missing some of the interdependencies.

I wouldn't mind either of those combinations.  Maybe rgmanager's last
stand will be in cluster.git anyway... if so, then it's not a factor.

I didn't have much reason for separating fence/fence-agents.  We're
planning on unifying it all anyway, even if the agents are done sooner.
And I don't think packaging/releasing agents separately should have much
bearing on the source tree?  (I've heard interest in putting agents in
their own package for Fedora.)

Dave
