From: Andreas Dilger <andreas.dilger@oracle.com>
Date: Thu, 03 Jun 2010 04:55:39 -0000
Subject: [Ocfs2-devel] [PATCH V2 0/7] Cleancache (was Transcendent
	Memory): overview
In-Reply-To: <4C07179F.5080106@vflare.org>
References: <20100528173510.GA12166%ca-server1.us.oracle.comAANLkTilV-4_QaNq5O0WSplDx1Oq7JvkgVrEiR1rgf1up@mail.gmail.com>
	<489aa002-6d42-4dd5-bb66-81c665f8cdd1@default>
	<4C07179F.5080106@vflare.org>
Message-ID: <3721BEE2-DF2D-452A-8F01-E690E32C6B33@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ngupta@vflare.org
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, Minchan Kim <minchan.kim@gmail.com>, chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com

On 2010-06-02, at 20:46, Nitin Gupta wrote:
> On 06/03/2010 04:32 AM, Dan Magenheimer wrote:
>>> From: Minchan Kim [mailto:minchan.kim at gmail.com]
>> 
>>>> I am also eagerly awaiting Nitin Gupta's cleancache backend
>>>> and implementation to do in-kernel page cache compression.
>>> 
>>> Do Nitin say he will make backend of cleancache for
>>> page cache compression?
>>> 
>>> It would be good feature.
>>> I have a interest, too. :)
>> 
>> That was Nitin's plan for his GSOC project when we last discussed
>> this.  Nitin is on the cc list and can comment if this has
>> changed.
> 
> Yes, I have just started work on in-kernel page cache compression
> backend for cleancache :)

Is there a design doc for this implementation?  I was thinking it would be quite clever to do compression in, say, 64kB or 128kB chunks in a mapping (to get decent compression) and then write these compressed chunks directly from the page cache to disk in btrfs and/or a revived compressed ext4.

That would mean that the on-disk compression algorithm needs to match the in-memory algorithm, which implies that the in-memory compression algorithm should be selectable on a per-mapping basis.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.
