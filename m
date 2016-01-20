From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 20 Jan 2016 16:09:27 +0800
Subject: [Ocfs2-devel] ocfs2: o2hb: not fence self if storage down
In-Reply-To: <569F92E8020000F900026595@relay2.provo.novell.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
	<569F92E8020000F900026595@relay2.provo.novell.com>
Message-ID: <569F40B7.3040301@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,

On 01/20/2016 02:00 PM, Gang He wrote:
> Hi Junxiao,
> 
> Thank for your fix.
> Just one quick question, this fix only effects OCFS2 O2CB case, right?
Right.
> If the user selects pacemaker as cluster stack? OCFS2 file system will encounter the same problem?
Not sure about this, i have no knowledge about packmaker. You can run a
quick test on the setup.

Thanks,
Junxiao.
> 
> Thanks
> Gang 
> 
> 
>>>>
>> Hi,
>>
>> This serial of patches is to fix the issue that when storage down,
>> all nodes will fence self due to write timeout.
>> With this patch set, all nodes will keep going until storage back
>> online, except if the following issue happens, then all nodes will
>> do as before to fence self.
>> 1. io error got
>> 2. network between nodes down
>> 3. nodes panic
>>
>> Junxiao Bi (6):
>>       ocfs2: o2hb: add negotiate timer
>>       ocfs2: o2hb: add NEGO_TIMEOUT message
>>       ocfs2: o2hb: add NEGOTIATE_APPROVE message
>>       ocfs2: o2hb: add some user/debug log
>>       ocfs2: o2hb: don't negotiate if last hb fail
>>       ocfs2: o2hb: fix hb hung time
>>
>>  fs/ocfs2/cluster/heartbeat.c |  181 
>> ++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 175 insertions(+), 6 deletions(-)
>>
>>  Thanks,
>>  Junxiao.
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
