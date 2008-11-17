From: Fabio M. Di Nitto <fdinitto@redhat.com>
Date: Mon, 17 Nov 2008 11:37:14 +0100
Subject: [Ocfs2-devel] [Cluster-devel] [RFC] Splitting cluster.git into
 separate projects/trees
In-Reply-To: <26ef5e70811170225m203fda49ubba54857c8c8cffd@mail.gmail.com>
References: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
	<20081114172530.GB4054@redhat.com>
	<20081114173743.GC18678@ca-server1.us.oracle.com>
	<26ef5e70811141311u54f5c2d6j873e5fd3977336ea@mail.gmail.com>
	<20081114215718.GA7394@redhat.com>
	<1226901177.2447.30.camel@daitarn-fedora.int.fabbione.net>
	<26ef5e70811170052j11c6ee94od6a5588288c13a0b@mail.gmail.com>
	<1226916165.2447.39.camel@daitarn-fedora.int.fabbione.net>
	<26ef5e70811170225m203fda49ubba54857c8c8cffd@mail.gmail.com>
Message-ID: <1226918234.2447.40.camel@daitarn-fedora.int.fabbione.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 2008-11-17 at 11:25 +0100, Andrew Beekhof wrote:
> On Mon, Nov 17, 2008 at 11:02, Fabio M. Di Nitto <fdinitto@redhat.com> wrote:
> > On Mon, 2008-11-17 at 09:52 +0100, Andrew Beekhof wrote:
> >> On Mon, Nov 17, 2008 at 06:52, Fabio M. Di Nitto <fdinitto@redhat.com> wrote:
> 
> >> > There is actually an important difference for me to keep them separated.
> >> >
> >> > Each time we do a package update, the whole set of daemons will need to
> >> > go through testing again, even if they didn't change a bit.
> >>
> >> True.
> >>
> >> Random thought - how about having the resource and fence agents together?
> >> Similar things with similar update frequencies...
> >
> > hmmm no.. same reason. they have different tasks.. different subsystems
> > etc.
> 
> They're still scripts though (and there's not much more difference
> between an IP and IPMI script than there is between an IP and Apache
> script).
> And I'd guess that the chances of each set needing a refresh is about
> the same at any given point in time...

You would still end up with the testing issue we try to avoid by keeping
daemons and agents separated.

Fabio
