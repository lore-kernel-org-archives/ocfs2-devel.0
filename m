From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 16 May 2014 10:19:20 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: o2net: fix packets lost issue
 when reconnect
In-Reply-To: <53747A65.1000200@huawei.com>
References: <1400127983-9774-1-git-send-email-junxiao.bi@oracle.com>
	<53747A65.1000200@huawei.com>
Message-ID: <537575A8.8080600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 05/15/2014 04:27 PM, Joseph Qi wrote:
> On 2014/5/15 12:26, Junxiao Bi wrote:
>> Hi,
>>
>> After the tcp connection is established between two ocfs2 nodes, an idle
>> timer will be set to check its state periodically, if no messages are
>> received during this time, idle timer will timeout, it will shutdown
>> the connection and try to rebuild, so pending message in tcp queues will
>> be lost. This may cause the whole ocfs2 cluster hung. 
>> This is very possible to happen when network state goes bad. Do the
>> reconnect is useless, it will fail if network state doesn't recover.
>> Just waiting there for network recovering may be a good idea, it will
>> not lost messages and some node will be fenced until cluster goes into
>> split-brain state, for this case, Tcp user timeout is used to override
>> the tcp retransmit timeout. It will timeout after 25 days, user should
>> have notice this through the provided log and fix the network, if they
>> don't, ocfs2 will fall back to original reconnect way.
>> The following is the serial of patches to fix the bug. Please help review.
> TCP RTT is auto-regressive, that means the following case may take
> place:
> Suppose current retransmission interval is ?T (somewhat long), network
> recovers but down again before the next retransmission windows
> comes (< ?T), so the network recovery won't be detected and ocfs2
> cluster still hungs.
Network recovers but down again, this means the network is still down.
Ocfs2 hung is an expected behavior when network is down if split-brain case.
What we need take care is how long can ocfs2 recover from hung after
network recover(not down again). I didn't know tcp internal about how
they retransmit the packets, I just test blocking the network for half
an hour, it just need several seconds to recover from the hung.  Of
course, how long the hung recover may also depends on how hard it hung
from dlm.

Thanks,
Junxiao.
>> Thanks,
>> Junxiao.
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>>
>
