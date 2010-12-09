From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 09 Dec 2010 10:24:41 -0800
Subject: [Ocfs2-devel] [PATCH] Call userspace script when self-fencing
In-Reply-To: <20101209101143.4niwmlbyjccc0444@webmail.astek.fr>
References: <20101209101143.4niwmlbyjccc0444@webmail.astek.fr>
Message-ID: <4D011EE9.2020003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Is it safe to call usermode_helper from an interrupt context?

Even if it is safe, we cannot do this because we cannot rely on an
external script. Any delay and either the cluster hangs or worse,
corruption.

If you want to use external fencing, then my suggestion would be
to look at latest fedora, opensuse, ubuntu, debian or sles11 which
bundle ocfs2 and the pacemaker cluster stack. You can then configure
ocfs2 to use the pcmk stack and make use of its different fencing
agents.

On 12/09/2010 01:11 AM, nagius at astek.fr wrote:
>
> Hi,
>
> According to comments in file fs/ocfs2/cluster/quorum.c:70 about the self-fencing operations :
>
> /* It should instead flip the file
>  * system RO and call some userspace script. */
>
> So, I tried to add it (but i did'nt find a way to flip the fs in RO).
>
> Here is a proposal for this functionnality, based on ocfs2-1.4.7.
> This patch add an entry 'fence_cmd' in /sys to specify an userspace fence script.
> This behavior can be selected by echoing the new keyword 'cmd' in fence_method.
>
> Example :
>
> echo "/usr/local/sbin/my_fencer"> /sys/kernel/config/cluster/ocfs2/fence_cmd
> echo "cmd"> /sys/kernel/config/cluster/ocfs2/fence_method
>
>
> Hope this could interest someone.
>
> Nicolas AGIUS
>
>
>
> ----------------------------------------------------------------
> This message was sent using IMP, the Internet Messaging Program.
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101209/60f3fa54/attachment.html 
