From: Manish Singh <manish.singh@oracle.com>
Date: Mon Aug 15 17:14:45 2005
Subject: [Ocfs2-devel] ocfs2-1.0.1 ebuilds
In-Reply-To: <43010710.2060800@yu.net>
References: <42F800E5.2080706@yu.net> <43010710.2060800@yu.net>
Message-ID: <20050815221450.GA29912@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 15, 2005 at 11:20:16PM +0200, lazar obradovic wrote:
> Gentoo ocfs2 1.0.1 ebuilds are available from 
> http://bugs.gentoo.org/show_bug.cgi?id=98024

A few comments and questions:

> KEYWORDS="-* ~x86"

Does that mean this is only enabled for x86 platforms? 1.0.x works on
x86_64 and ia64 too.

The glib2 dependency in the tools should not be in the gtk2 option,
since ocfs2cdsl and debug.ocfs2 depend on it too, and they are command
line tools. Passing --disable-gtktest in the non-gtk2 case is kind of
silly, since there isn't any test for gtk itself, only pygtk.

The python binding for VTE is needed for some ocfs2console functionality
(though it does work without it).

Why are you using --prefix=/ ?

It looks like you are still installing a sample cluster.conf. This makes
no sense, there's no sane defaults for it, and putting the sample will
only lead to confusion.

Replacing the o2cb init script with your own is a bad idea. This makes
the gentoo distribution gratuitiously incompatible with the OCFS2
documentation out there, as well as breaking some ocfs2console
functionality. Please don't do this.

-Manish
