From: Andrew Beekhof <beekhof@gmail.com>
Date: Wed, 4 Mar 2009 21:31:17 +0100
Subject: [Ocfs2-devel] Patch to Pacemaker hooks in ocfs2_controld
In-Reply-To: <20090304193011.GB27565@mail.oracle.com>
References: <D8579235-5640-43E5-9B8D-F9B469021ABE@gmail.com>
	<20090304193011.GB27565@mail.oracle.com>
Message-ID: <26ef5e70903041231o31854e8ai5e2da64f2debcea9@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 4, 2009 at 20:30, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Wed, Mar 04, 2009 at 09:21:48AM +0100, Andrew Beekhof wrote:
>> Hi Guys,
>>
>> I overhauled and simplified the Pacemaker hooks recently. ?This patch:
>> - Reuses more code from the Pacemaker libraries
>> - Escalates fencing to the cluster manager instead of initiating it
>> directly
>
> ? ? ? ?I like these parts.
>
>> Attached patch is against master, or you can pull the original patch
>> which is against an older version used by SUSE:
>> ? http://git.clusterlabs.org/?p=ocfs2-tools.git;a=commit;h=dfc25180085c160baff412eb7423c6285cb166a9
>>
>
> ? ? ? ?Ugh, your mail client attached it in a way that makes it
> not appear in my quoted reply text. ?Weird.
> ? ? ? ?I'll trust that you got the ais/pcmk interaction code right - it
> looks ok on the face, but I'm not familiar with it.
> ? ? ? ?I don't like log_printf(). ?First because log_error() already
> exists for LOG_ERR printing, second because you strip out all the useful
> log_debug() calls, but most of all because your log_printf() doesn't add
> to the internal daemon ring buffer. ?So debugfs.ocfs2 -R 'controld dump'
> doesn't show those messages.
> ? ? ? ?Is there a reason log_error() didn't work for you?

Re: log_error, I think I was just trying to be consistent with the
other calls I saw.
But I was working with the dlm_controld hooks at the same time so I
may have gotten my wires crossed.

Re: log_debug, I got complaints about the logging being too noisy.
Plus there's not a lot of logging in the rest of ocfs2_controld, so in
many ways its more consistent ;-)

Would you be interested in a patch that adds more logging to the rest
of ocfs2_controld?
The lack of logging, particularly in some of the error paths, has been
killing us.
