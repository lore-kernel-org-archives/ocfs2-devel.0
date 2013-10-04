From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 04 Oct 2013 10:01:34 -0500
Subject: [Ocfs2-devel] [PATCH 0/5] nocontrold: Eliminating
 ocfs2_controld v3
In-Reply-To: <20131003112528.GR20001@suse.de>
References: <20131003054851.GA12878@shrek.lan> <20131003112528.GR20001@suse.de>
Message-ID: <524ED84E.4040109@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/03/2013 06:25 AM, Lars Marowsky-Bree wrote:
> On 2013-10-03T00:48:55, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> Hi Goldwyn,
>
> just a minor comment:
>
>> For backward compatibility, we are keeping the controld handling code. Once
>> enough time has passed we can remove a significant portion of the code.
>
> Can we add this to Documentation/fs/ocfs2.txt, or maybe print a one-time
> message on activating the deprecated mode with an intended removal date?
> (I'd propose end-of-2014.)

We already print a message in dmesg saying:
printk(KERN_NOTICE "ocfs2: You seem to be using an older "
                    "version of dlm_controld and/or ocfs2-tools."
                    " Please consider upgrading.\n");

Adding a date to this should not be a problem.

>
> And, perhaps, a compile-time option to disable this earlier, so that
> users can choose the stacks they want to build the kernel with.
>

This would a be a couple of ifdef's in user_cluster_connect(). What do 
other ocfs2 developers feel about this?


-- 
Goldwyn
