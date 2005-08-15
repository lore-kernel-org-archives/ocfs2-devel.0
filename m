From: lazar obradovic <laza@yu.net>
Date: Mon Aug 15 18:23:19 2005
Subject: [Ocfs2-devel] ocfs2-1.0.1 ebuilds
In-Reply-To: <20050815221450.GA29912@ca-server1.us.oracle.com>
References: <42F800E5.2080706@yu.net> <43010710.2060800@yu.net>
	<20050815221450.GA29912@ca-server1.us.oracle.com>
Message-ID: <4301242D.7090902@yu.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Manish Singh wrote:

>A few comments and questions:
>  
>

Thanks for the feedback.

>>KEYWORDS="-* ~x86"
>>    
>>
>
>Does that mean this is only enabled for x86 platforms? 1.0.x works on
>x86_64 and ia64 too.
>  
>
Yes, and it's masked unstable for x86.
I was not aware of the fact that it also works on amd64 and ia64 (though 
I see a lot of *-endian fixups lately), so I'll mark it unstable on 
those platforms as well.
ocfs2 is definitely not working on ppc, ppc64, mips, sparc, alpha or 
hppa, nor will, in the near future?

>The glib2 dependency in the tools should not be in the gtk2 option,
>since ocfs2cdsl and debug.ocfs2 depend on it too, and they are command
>line tools. 
>
Will correct it, thanks.

>Passing --disable-gtktest in the non-gtk2 case is kind of
>silly, since there isn't any test for gtk itself, only pygtk.
>  
>
gtktest broke the emerge of ocfs2-tools and --disable-gtktest seem to work.
I'll check the exact reason for it and offer a solution instead of 
workaround, but until then, it's best if it stays like this.

>The python binding for VTE is needed for some ocfs2console functionality
>(though it does work without it).
>  
>
Thanks for this one too, I'll add VTE to deps list.

>Why are you using --prefix=/ ?
>  
>
econf is a wrapper around configure script that gives gentoo-defaults of 
paths to regular configure. Among these, default value for prefix is 
/usr, so it would break o2cb_ctl (as a workaround, init script could 
update /proc/sys/fs/ocfs2/nm/hb_ctl_path but I find that dirtier than 
giving --prefix=/ to econf).
On the other hand, this leads to installation of python extensions under 
/lib, instead of /usr/lib, which is fixed later, during src_install... 
Confiure's python.m4 should probably be updated to properly detect 
pyexecdir (or, perhaps, give the option to specify it).

>It looks like you are still installing a sample cluster.conf. This makes
>no sense, there's no sane defaults for it, and putting the sample will
>only lead to confusion.
>  
>
Gentoo's config protection will take care of that during the upgrades, 
and I find templates with bogus data rather useful for a quick 
first-time configuration... If you insist, I could push the empty config 
for first-time installs, with commented templates...

>Replacing the o2cb init script with your own is a bad idea. This makes
>the gentoo distribution gratuitiously incompatible with the OCFS2
>documentation out there, as well as breaking some ocfs2console
>functionality. Please don't do this.
>  
>
As stated in INSTALL.GENTOO:

---8<---
KNOWN BUGS
==========
1. Init script does not have all the functionality as o2cb script
----------------------------------------------------------------
I know that, but o2cb script doesn't use "depend" and therefore it's start
can't be controlled inside runlevel. I had to rewrite major portions of it
to make it gentoo-friendly. o2cb is still available, and if you need
additional functionality from /etc/init.d/ocfs2, file a bugreport (see
"Reporting Bugs" below).
---8<---

That's why Gentoo init script is not called o2cb, but simple ocfs2, 
since it's not a full replacement. As users request, I'll add parts to 
ocfs2.init, and untill that, o2cb is still available.

Once again, thanks for the feedback.

-- 
LO275-RIPE
