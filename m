From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 02 Jun 2010 13:24:36 -0000
Subject: [Ocfs2-devel] [PATCH V2 0/7] Cleancache (was Transcendent
	Memory): overview
In-Reply-To: <20100528173510.GA12166@ca-server1.us.oracle.com>
References: <20100528173510.GA12166@ca-server1.us.oracle.com>
Message-ID: <20100602132427.GA32110@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com

Please give your patches some semi-resonable subject line.

>  fs/btrfs/super.c           |    2 
>  fs/buffer.c                |    5 +
>  fs/ext3/super.c            |    2 
>  fs/ext4/super.c            |    2 
>  fs/mpage.c                 |    7 +
>  fs/ocfs2/super.c           |    3 
>  fs/super.c                 |    8 +

This is missing out a whole lot of filesystems.  Even more so why the
hell do you need hooks into the filesystem?
