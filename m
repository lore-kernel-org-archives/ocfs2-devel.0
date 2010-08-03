From: Andreas Dilger <andreas.dilger@oracle.com>
Date: Tue, 3 Aug 2010 12:34:19 -0600
Subject: [Ocfs2-devel] [PATCH V3 0/8] Cleancache: overview
In-Reply-To: <a7f4db53-c348-4cff-8762-7ea4031e4813@default>
References: <20100621231809.GA11111%ca-server1.us.oracle.com4C49468B.40307@vflare.org>
	<840b32ff-a303-468e-9d4e-30fc92f629f8@default>
	<20100723140440.GA12423@infradead.org>
	<364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default>
	<a7f4db53-c348-4cff-8762-7ea4031e4813@default>
Message-ID: <22A6238E-0BA4-4AB9-A4FA-28B206A47513@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, ngupta@vflare.org, akpm@linux-foundation.org, Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org, JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>, npiggin@suse.de, Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>

On 2010-08-03, at 11:35, Dan Magenheimer wrote:
> - The FS should be block-device-based (e.g. a ram-based FS
>  such as tmpfs should not enable cleancache)

When you say "block device based", does this exclude network filesystems?  It would seem cleancache, like fscache, is actually best suited to high-latency network filesystems.

> - To ensure coherency/correctness, inode numbers must be unique
>  (e.g. no emulating 64-bit inode space on 32-bit inode numbers)

Does it need to be restricted to inode numbers at all (i.e. can it use an opaque internal identifier like the NFS file handle)?  Disallowing cleancache on a filesystem that uses 64-bit (or larger) inodes on a 32-bit system reduces its usefulness.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.
