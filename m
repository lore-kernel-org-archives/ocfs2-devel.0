From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Thu, 26 Sep 2013 17:22:12 -0500
Subject: [Ocfs2-devel] [PATCH 0/6] nocontrold: Eliminating ocfs2_controld
In-Reply-To: <20130906193846.GA31381@wotan.suse.de>
References: <20130906032651.GA4148@shrek.lan> <20130906112253.GQ1553@suse.de>
	<522A293C.7050800@suse.de> <20130906193846.GA31381@wotan.suse.de>
Message-ID: <5244B394.3010307@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Thanks for the review so far. I was on vacation and could not get back 
to this earlier.

On 09/06/2013 02:38 PM, Mark Fasheh wrote:
> On Fri, Sep 06, 2013 at 02:13:00PM -0500, Goldwyn Rodrigues wrote:
>> Hi Lars,
>>
>> On 09/06/2013 06:22 AM, Lars Marowsky-Bree wrote:
>>> On 2013-09-05T22:26:56, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>>>
>>> Hi Goldwyn,
>>>
>>> thanks! This looks really good.
>>>
>>>> This is an effort of removing ocfs2_controld.pcmk and getting ocfs2 DLM
>>>> handling up to the times with respect to DLM (>=4.0.1) and corosync
>>>> (2.3.x). AFAIK, cman also is being phased out for a unified corosync
>>>> cluster stack.
>>>
>>> That's clearly necessary, also to bring OCFS2 more uptodate with the
>>> latest happenings in the GFS2 world; it'll allow both file systems to
>>> share exactly the same cluster stack.
>>>
>>>> https://github.com/goldwynr/ocfs2-tools branch: nocontrold
>>>> Currently, not many checks are present in the userspace code,
>>>> but that would change soon.
>>>
>>> There's one question I have; how will this handle
>>>
>>> - the "old" user-space code starting on a new kernel,
>>
>> The ocfs2_controld.pcmk will refuse to start because of absence of the
>> control device created by the kernel. Of course, this would deny mounts
>> as well.
>
> Do we know how the GFS2 project handled this case? It's going to be a major
> problem for people if a kernel update horks their cluster fs.

Okay, I have managed to work on this and can mount filesystems which are 
used with ocfs2_controld. So, we have backward compatibility.

The only downside is we will not have a code reduction :( I will post 
the patches soon for review.

>
>
>>> Is there anything we can do to at least provide a meaningful error
>>> message in the first case? The second should be easier to handle.
>>
>> Yes, we can capture the error code and ask the user to upgrade in the
>> second case. However, for the first case mount.ocfs2 would give a
>> cluster connect failure because ocfs2_controld is not present.
>>
>> On a different note, we should consider increasing the kernel module
>> version shown in dmesg to be in sync with the userspace tools and/or
>> possibly increase the version number of both tools and kernel module.
>
> That shouldn't be a problem, the numbers are mostly there for us Ocfs2 devs.

Understood. I hope the devs at Oracle does too :) especially from the 
tools POV.


-- 
Goldwyn
