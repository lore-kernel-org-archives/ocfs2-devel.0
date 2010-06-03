From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Thu, 03 Jun 2010 00:21:11 -0000
Subject: [Ocfs2-devel] [PATCH V2 2/7] Cleancache (was Transcendent
	Memory): core files
In-Reply-To: <0be9e88e-7b0d-471d-8d49-6dc593dd43be@default>
References: <20100528173550.GA12219@ca-server1.us.oracle.com
	20100602122900.6c893a6a.akpm@linux-foundation.org>
	<0be9e88e-7b0d-471d-8d49-6dc593dd43be@default>
Message-ID: <4C06F571.3050306@goop.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, chris.mason@oracle.com, viro@zeniv.linux.org.uk, adilger@Sun.COM, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com

On 06/02/2010 05:06 PM, Dan Magenheimer wrote:
> It is intended that there be different flavours but only
> one can be used in any running kernel.  A driver file/module
> claims the cleancache_ops pointer (and should check to ensure
> it is not already claimed).  And if nobody claims cleancache_ops,
> the hooks should be as non-intrusive as possible.
>
> Also note that the operations occur on the order of the number
> of I/O's, so definitely a lot, but "zillion" may be a bit high. :-)
>
> If you think this is a showstoppper, it could be changed
> to be bound only at compile-time, but then (I think) the claimer
> could never be a dynamically-loadable module.
>   

Andrew is suggesting that rather than making cleancache_ops a pointer to
a structure, just make it a structure, so that calling a function is a
matter of cleancache_ops.func rather than cleancache_ops->func, thereby
avoiding a pointer dereference.

    J
