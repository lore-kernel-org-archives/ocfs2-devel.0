From: Manish Singh <manish.singh@oracle.com>
Date: Mon Aug 15 19:26:50 2005
Subject: [Ocfs2-devel] ocfs2-1.0.1 ebuilds
In-Reply-To: <4301242D.7090902@yu.net>
References: <42F800E5.2080706@yu.net> <43010710.2060800@yu.net>
	<20050815221450.GA29912@ca-server1.us.oracle.com>
	<4301242D.7090902@yu.net>
Message-ID: <20050816002655.GA9031@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 16, 2005 at 01:24:29AM +0200, lazar obradovic wrote:
> Manish Singh wrote:
> 
> >A few comments and questions:
> > 
> >
> 
> Thanks for the feedback.
> 
> >>KEYWORDS="-* ~x86"
> >>   
> >>
> >
> >Does that mean this is only enabled for x86 platforms? 1.0.x works on
> >x86_64 and ia64 too.
> > 
> >
> Yes, and it's masked unstable for x86.
> I was not aware of the fact that it also works on amd64 and ia64 (though 
> I see a lot of *-endian fixups lately), so I'll mark it unstable on 
> those platforms as well.

Well, amd64 and ia64 are little endian too, so 1.0.x works fine.

> ocfs2 is definitely not working on ppc, ppc64, mips, sparc, alpha or 
> hppa, nor will, in the near future?

The big endian support is in 1.1.x now. So all those arches work in the
bleeding edge code.

> >The glib2 dependency in the tools should not be in the gtk2 option,
> >since ocfs2cdsl and debug.ocfs2 depend on it too, and they are command
> >line tools. 
> >
> Will correct it, thanks.
> 
> >Passing --disable-gtktest in the non-gtk2 case is kind of
> >silly, since there isn't any test for gtk itself, only pygtk.
> > 
> >
> gtktest broke the emerge of ocfs2-tools and --disable-gtktest seem to work.
> I'll check the exact reason for it and offer a solution instead of 
> workaround, but until then, it's best if it stays like this.

Something else must've broken then, since there simply is no gtk2 test
performed. Perhaps you're confusing things with --disable-glibtest,
which should've been addressed if you get the glib2 dependencies right.
 
> >The python binding for VTE is needed for some ocfs2console functionality
> >(though it does work without it).
> > 
> >
> Thanks for this one too, I'll add VTE to deps list.
> 
> >Why are you using --prefix=/ ?
> > 
> >
> econf is a wrapper around configure script that gives gentoo-defaults of 
> paths to regular configure. Among these, default value for prefix is 
> /usr, so it would break o2cb_ctl (as a workaround, init script could 
> update /proc/sys/fs/ocfs2/nm/hb_ctl_path but I find that dirtier than 
> giving --prefix=/ to econf).

No, it wouldn't. You're supposed to use --prefix=/usr. There's a
separate --root-prefix which defaults to /, where stuff like o2cb_ctl
lands.

This is the same semantics as e2fsprogs.

> On the other hand, this leads to installation of python extensions under 
> /lib, instead of /usr/lib, which is fixed later, during src_install... 
> Confiure's python.m4 should probably be updated to properly detect 
> pyexecdir (or, perhaps, give the option to specify it).

And if you do --prefix=/usr, this is a non-issue.

> >It looks like you are still installing a sample cluster.conf. This makes
> >no sense, there's no sane defaults for it, and putting the sample will
> >only lead to confusion.
> > 
> >
> Gentoo's config protection will take care of that during the upgrades, 
> and I find templates with bogus data rather useful for a quick 
> first-time configuration... If you insist, I could push the empty config 
> for first-time installs, with commented templates...

Users are expected to use ocfs2console to make the config file, so this
stuff is really for advanced users. If you really want a sample there,
then yeah, have it all commented out. Actually having it active is bad,
since you currently can't remove nodes out of a live cluster
configuration. So having a fake configuration will be bad news for users
who use ocfs2console to make their cluster config.
 
> >Replacing the o2cb init script with your own is a bad idea. This makes
> >the gentoo distribution gratuitiously incompatible with the OCFS2
> >documentation out there, as well as breaking some ocfs2console
> >functionality. Please don't do this.
> > 
> >
> As stated in INSTALL.GENTOO:
> 
> ---8<---
> KNOWN BUGS
> ==========
> 1. Init script does not have all the functionality as o2cb script
> ----------------------------------------------------------------
> I know that, but o2cb script doesn't use "depend" and therefore it's start
> can't be controlled inside runlevel. I had to rewrite major portions of it
> to make it gentoo-friendly. o2cb is still available, and if you need
> additional functionality from /etc/init.d/ocfs2, file a bugreport (see
> "Reporting Bugs" below).
> ---8<---
> 
> That's why Gentoo init script is not called o2cb, but simple ocfs2, 
> since it's not a full replacement. As users request, I'll add parts to 
> ocfs2.init, and untill that, o2cb is still available.

ocfs2console expects there to be an /etc/init.d/o2cb, and expects
start/stop/online semantics. Otherwise the cluster configuration
functionality will be degraded.

If o2cb.init needs a "depend" to be happy with Gentoo, please provide a
patch to o2cb.init that provides this. Implementing a separate init
script that does different things than every other Linux distribution
creates user confusion.

Also, the cluster stack only supports having a single cluster right now,
so the stuff in ocfs2.conf is misleading.

-Manish
