From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Sun, 03 Nov 2013 21:48:07 -0600
Subject: [Ocfs2-devel] [PATCH 0/6] nocontrold: Eliminating
 ocfs2_controld v4
In-Reply-To: <20131104004949.GJ29346@wotan.suse.de>
References: <20131018144449.GA4568@shrek.lan>
	<20131104004949.GJ29346@wotan.suse.de>
Message-ID: <527718F7.4030104@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/03/2013 06:49 PM, Mark Fasheh wrote:
> On Fri, Oct 18, 2013 at 09:44:54AM -0500, Goldwyn Rodrigues wrote:
>> Hi,
>>
>> This is an effort of removing ocfs2_controld.pcmk and getting ocfs2 DLM
>> handling up to the times with respect to DLM (>=4.0.1) and corosync
>> (2.3.x). AFAIK, cman also is being phased out for a unified corosync
>> cluster stack.
>
> Thanks again for doing this work. I'm about halfway done with the patches
> when I write this but things seem to be coming along well.
>
>
>> fs/dlm performs all the functions with respect to fencing and node
>> management and provides the API's to do so for ocfs2. For all future
>> references, DLM stands for fs/dlm code.
>>
>> The advantages are:
>>   + No need to run an additional userspace daemon (ocfs2_controld)
>>   + No contrrold devince handling and controld protocol
>>   + Shifting responsibilities of node management to DLM layer
>>
>> For backward compatibility, we are keeping the controld handling code. Once
>> enough time has passed we can remove a significant portion of the code.
>
> Can you give us some brief details on how backwards compatibility was
> tested? I have a feeling that it would alleviate some concerns we had about
> that when the 1st series hit ocfs2-devel.

I ran the code with an unmodified ocfs2-tools/libdlm and it worked fine 
and I got the expected message of upgrading dlm/ocfs2-tools.

I checked the reverse (older kernel, newer tools) as well, and mount 
returned ESRCH because ocfs2_controld was not running.


-- 
Goldwyn
