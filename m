From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 9 Oct 2018 15:40:16 -0700
Subject: [Ocfs2-devel] [PATCH] fs/ocfs2/dlmglue: lockdep_keys defined
	but not used
In-Reply-To: <20181009182217.GA18663@zn.tnic>
References: <20180704095318.19218-1-anders.roxell@linaro.org>
	<CAMuHMdWCyH-E9VA7ihsoXEq4dvLrPjYd01TYot6qja-psVRcog@mail.gmail.com>
	<CADYN=9KH134zWogYt=FMMTgsYm6GEqBUY6=C453yj_NY=oq1hg@mail.gmail.com>
	<20181009182217.GA18663@zn.tnic>
Message-ID: <20181009154016.5f5d044111e14bc38a7313c8@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Borislav Petkov <bp@alien8.de>
Cc: Anders Roxell <anders.roxell@linaro.org>, geert@linux-m68k.org, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, 9 Oct 2018 20:22:17 +0200 Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Aug 24, 2018 at 03:07:03PM +0200, Anders Roxell wrote:
> > On Thu, 23 Aug 2018 at 23:07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > >
> > > Hi Anders,
> > >
> > > On Wed, Jul 4, 2018 at 11:54 AM Anders Roxell <anders.roxell@linaro.org> wrote:
> > > > When CONFIG_DEBUG_LOCK_ALLOC isn't enabled lockdep_keys isn't used and
> > > > we get a warning:
> > > > fs/ocfs2/dlmglue.c:99:30: warning: ?lockdep_keys? defined but not used
> > > >     [-Wunused-variable]
> > > >  static struct lock_class_key lockdep_keys[OCFS2_NUM_LOCK_TYPES];
> > > >                               ^~~~~~~~~~~~
> > > > Adding __maybe_unused to the declaration hids the warning.
> > >
> > > Thanks for your patcj!
> > >
> > > > Fixes: 1cd75cdb8fbb ("ocfs2: make several functions and variables static (and some const)")
> > >
> > > Fixes: 480bd56485b77c36 ("ocfs2: make several functions and variables
> > > static (and some const)")
> > 
> > Thanks, thats correct.
> > 
> > >
> > > Presumably the branch got rebased?
> > 
> > probably.
> > 
> > Mark, Joel, do you want me to send a new patch where I correct the sha
> > in the "Fixes" part of the changelog or can you fix that?
> 
> FWIW, I'm still seeing this in randconfig builds here.
> 
> Adding akpm in case no one picks this up.
> 

https://urldefense.proofpoint.com/v2/url?u=https-3A__ozlabs.org_-7Eakpm_mmots_broken-2Dout_ocfs2-2Dfix-2Da-2Dgcc-2Dcompiled-2Dwarning.patch&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=ZgrEA8A7Y3uhOY_9E-LiO-1D-nKZBJFblr7eFxH1PJQ&s=oPfnKW2LN9kXYh_vXc6gAoA7ts1TUH1WtFmKVdZ4Kjw&e=
is queued for 4.20-rc1.  I'll see if we can squeeze it into 4.19.
