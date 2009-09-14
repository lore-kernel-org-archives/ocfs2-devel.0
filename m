From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 14 Sep 2009 12:30:39 -0700
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4AACFCEB.4060902@suse.de>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de> <4A9FEDAC.50704@oracle.com>
	<4AA80AE4.9090105@suse.de> <4AA82136.9000403@oracle.com>
	<4AA890ED.3040406@suse.de> <4AAAD5C6.4000800@oracle.com>
	<4AACFCEB.4060902@suse.de>
Message-ID: <4AAE99DF.3030005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks. Can you email me the _full_ trace log.

Coly Li wrote:
> Hi Sunil,
>
> Here is the printk info from your patch. I patched it into 2.6.31-rc8.
>
> This time it's quite easy to wait for the open file blocking happens. All the
> trace info on all 2 nodes (x1, and x2) are taken in blocking time.
>
> Thanks.
>
> Sunil Mushran Wrote:
>   
>> Thanks, Coly.
>>
>> So dlmglue calls dlmlock to downconvert the lock from EX => NL.
>> However, in the next iteration, we see lock at PR. Strange.
>>
>> Anycase, I have created a patch that should provide more info.
>> The patch is against the current mainline. It should apply against
>> older trees. But may require a bit of tlc.
>>
>> Please re-run with the the following patch.
>> http://oss.oracle.com/~smushran/0001-ocfs2-Patch-to-debug-hang-in-dlmglue-when-running-d.patch
>>
>>     
>
>   
