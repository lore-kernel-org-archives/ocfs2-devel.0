From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 06 Sep 2013 14:13:00 -0500
Subject: [Ocfs2-devel] [PATCH 0/6] nocontrold: Eliminating ocfs2_controld
In-Reply-To: <20130906112253.GQ1553@suse.de>
References: <20130906032651.GA4148@shrek.lan> <20130906112253.GQ1553@suse.de>
Message-ID: <522A293C.7050800@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Lars,

On 09/06/2013 06:22 AM, Lars Marowsky-Bree wrote:
> On 2013-09-05T22:26:56, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> Hi Goldwyn,
>
> thanks! This looks really good.
>
>> This is an effort of removing ocfs2_controld.pcmk and getting ocfs2 DLM
>> handling up to the times with respect to DLM (>=4.0.1) and corosync
>> (2.3.x). AFAIK, cman also is being phased out for a unified corosync
>> cluster stack.
>
> That's clearly necessary, also to bring OCFS2 more uptodate with the
> latest happenings in the GFS2 world; it'll allow both file systems to
> share exactly the same cluster stack.
>
>> https://github.com/goldwynr/ocfs2-tools branch: nocontrold
>> Currently, not many checks are present in the userspace code,
>> but that would change soon.
>
> There's one question I have; how will this handle
>
> - the "old" user-space code starting on a new kernel,

The ocfs2_controld.pcmk will refuse to start because of absence of the 
control device created by the kernel. Of course, this would deny mounts 
as well.

> - or the "new" user-space code being run on an old kernel?

The kernel code will fail citing the reason: The userspace daemon is not 
present.
The userspace complains (ESRCH):
mount.ocfs2: No such process while mounting /dev/sdc1 on /mnt. Check 
'dmesg' for more information on this error.

>
> Is there anything we can do to at least provide a meaningful error
> message in the first case? The second should be easier to handle.

Yes, we can capture the error code and ask the user to upgrade in the 
second case. However, for the first case mount.ocfs2 would give a 
cluster connect failure because ocfs2_controld is not present.

On a different note, we should consider increasing the kernel module 
version shown in dmesg to be in sync with the userspace tools and/or 
possibly increase the version number of both tools and kernel module.

-- 
Goldwyn
