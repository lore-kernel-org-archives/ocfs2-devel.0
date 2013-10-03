From: Lars Marowsky-Bree <lmb@suse.de>
Date: Thu, 3 Oct 2013 13:25:28 +0200
Subject: [Ocfs2-devel] [PATCH 0/5] nocontrold: Eliminating
 ocfs2_controld v3
In-Reply-To: <20131003054851.GA12878@shrek.lan>
References: <20131003054851.GA12878@shrek.lan>
Message-ID: <20131003112528.GR20001@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013-10-03T00:48:55, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

Hi Goldwyn,

just a minor comment:

> For backward compatibility, we are keeping the controld handling code. Once
> enough time has passed we can remove a significant portion of the code.

Can we add this to Documentation/fs/ocfs2.txt, or maybe print a one-time
message on activating the deprecated mode with an intended removal date?
(I'd propose end-of-2014.)

And, perhaps, a compile-time option to disable this earlier, so that
users can choose the stacks they want to build the kernel with.


Thanks,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend?rffer, HRB 21284 (AG N?rnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
