From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Mon, 30 Aug 2010 17:40:42 -0700 (PDT)
Subject: [Ocfs2-devel] [PATCH V4 3/8] Cleancache: core ops functions and
	configuration
In-Reply-To: <4C7C3521.7090403@goop.org>
References: <20100830223133.GA1272@ca-server1.us.oracle.com
	4C7C3521.7090403@goop.org>
Message-ID: <dbb9f012-c09a-438f-99d0-4fbc40428f58@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org, JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk, Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie, yinghan@google.com, gthelen@google.com

> > +#ifdef CONFIG_CLEANCACHE
> > +#define cleancache_enabled (cleancache_ops.init_fs)
> 
> Pointers can be used in a boolean context, but it would probably be
> cleaner to have this evaluate to a proper boolean type.  Also I'd
> probably go with an all-caps macro name rather than making it look like
> a variable.

OK, thanks, will fix.
 
> > +/* useful stats available in /sys/kernel/mm/cleancache */
> > +static unsigned long succ_gets;
> > +static unsigned long failed_gets;
> > +static unsigned long puts;
> > +static unsigned long flushes;
> 
> I'd probably give these very generic-sounding names some slightly
> unique
> prefix just to help out people looking at "nm" output or using ctags.
> 
> > +static int get_key(struct inode *inode, struct cleancache_filekey
> *key)
> 
> Ditto.

OK, will do.

Thanks for the feedback!
Dan
