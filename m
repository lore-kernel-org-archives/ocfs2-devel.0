From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 08 Dec 2011 11:07:15 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: submit disk heartbeat bio using
 WRITE_SYNC
In-Reply-To: <4EDDA598.50708@tao.ma>
References: <1323147430-16691-1-git-send-email-n_iwamatsu@jp.fujitsu.com>
	<4EDDA598.50708@tao.ma>
Message-ID: <4EE10AE3.6090805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Sunil Mushran <sunil.mushran@oracle.com>

On 12/05/2011 09:18 PM, Tao Ma wrote:
> On 12/06/2011 12:57 PM, Noboru Iwamatsu wrote:
>> Under heavy I/O load, writing the disk heartbeat can be forced
>> to wait for minutes, and this causes the node to be fenced.
>>
>> This patch tries to use WRITE_SYNC in submitting the heartbeat
>> bio, so that writing the heartbeat will have a priority over
>> other requests.
>>
>> Signed-off-by: Noboru Iwamatsu<n_iwamatsu@jp.fujitsu.com>
> looks good to me.
> Acked-by: Tao Ma<boyu.mt@taobao.com>
>> ---
>>   fs/ocfs2/cluster/heartbeat.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
>> index 9a3e6bb..6b0c1e4 100644
>> --- a/fs/ocfs2/cluster/heartbeat.c
>> +++ b/fs/ocfs2/cluster/heartbeat.c
>> @@ -491,7 +491,7 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
>>   	}
>>
>>   	atomic_inc(&write_wc->wc_num_reqs);
>> -	submit_bio(WRITE, bio);
>> +	submit_bio(WRITE_SYNC, bio);
>>
>>   	status = 0;
>>   bail:
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
