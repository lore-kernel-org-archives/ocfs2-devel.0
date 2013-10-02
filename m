From: Lars Marowsky-Bree <lmb@suse.com>
Date: Wed, 02 Oct 2013 09:49:21 -0000
Subject: [Ocfs2-devel] [PATCH 3/7] Differentiate between no_controld and
 with_controld
In-Reply-To: <20130927170748.GA11716@shrek.lan>
References: <20130927170748.GA11716@shrek.lan>
Message-ID: <20131002094907.GS20001@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013-09-27T12:07:53, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> This is done primarily for backward compatibility. I hope we do
> away with this sooner than later ;)

I'd actually be quite happy if we could do away with this directly.

Users that want to remain on an older user-space code base can always
revert this or stick to a stable long-term kernel. That may be an
unpopular opinion ;-)

The relevant GFS2 commit seems to be
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/gfs2?id=e0c2a9aa1e68455dc3439e95d85cabcaff073666


Regards,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend?rffer, HRB 21284 (AG N?rnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
