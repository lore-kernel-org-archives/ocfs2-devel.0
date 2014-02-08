From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 08 Feb 2014 10:24:42 +0800
Subject: [Ocfs2-devel] [patch 09/11] ocfs2: llseek requires ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <52F587AB.3010604@huawei.com>
References: <20140124204709.85C895A4203@corp2gmr1-2.hot.corp.google.com>	<20140206234253.GR24361@wotan.suse.de>	<20140206155029.b7275670913c34ef6bc9a530@linux-foundation.org>	<20140207224409.GS24361@wotan.suse.de>
	<52F587AB.3010604@huawei.com>
Message-ID: <52F5956A.1090208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Canquan,

On 02/08 2014 09:26 AM, Jensen wrote:
> On 2014/2/8 6:44, Mark Fasheh wrote:
>> On Thu, Feb 06, 2014 at 03:50:29PM -0800, Andrew Morton wrote:
>>> On Thu, 6 Feb 2014 15:42:53 -0800 Mark Fasheh <mfasheh@suse.de> wrote:
>>>
>>>> On Fri, Jan 24, 2014 at 12:47:09PM -0800, akpm at linux-foundation.org wrote:
>>>>> From: Jensen <shencanquan@huawei.com>
>>>>> Subject: ocfs2: llseek requires ocfs2 inode lock for the file in SEEK_END
>>>>>
>>>>> llseek requires ocfs2 inode lock for updating the file size in SEEK_END. 
>>>>> because the file size maybe update on another node.
>>>>>
>>>>> This bug can be reproduce the following scenario: at first, we dd a test
>>>>> fileA, the file size is 10k.
>>>> Basically, you want to amke SEEK_END cluster-aware. This patch would be the
>>>> right way to do it.
>>> Sunil was worried about the performance impact.  Correctness beats
>>> performance, but some quantitative testing would be useful?
>> Performance is my primary concern as well. I thought of writing it up but
>> realized I don't really have any evidence off the top of my head one way or
>> the other that this might slow us down.
>>
>> That said, I kind of question the usefulness of this patch - we got
>> along pretty well so far without locking in lseek and some random dd(1) test
>> doesn't really provide a great end-user reason for why we should do this.
>>
>> I will note that gfs2 locks for SEEK_END.
>>
>>
>> Testing would help to answer this, yes. Jensen is this something you can do?
>> I'm not sure exactly what we would run yet though, I have to think about
>> that (or maybe someone can suggest something).
>>
>> Thanks,
>> 	--Mark
>>
>    ocfs2 is a cluster file system.  as like read/write/open/rmdir/unlink interface which think of cluster-aware. I think the seek interface need
>    cluster-aware. May be it has the performance impact. but it's correctness is more important than performance.

That would be great if you can show any testing results regarding performance
as you're the author of this patch and if you'd like to continue to push it,
though this is not requested always.


Thanks,
-Jeff
