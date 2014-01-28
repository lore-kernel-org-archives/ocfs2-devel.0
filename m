From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 28 Jan 2014 09:02:05 +0800
Subject: [Ocfs2-devel] [patch 02/11] ocfs2: free allocated clusters if
 error occurs after ocfs2_claim_clusters
In-Reply-To: <20140127150722.ec1bb078cd4ae18f44ece9ae@linux-foundation.org>
References: <20140124204701.6AC005A4203@corp2gmr1-2.hot.corp.google.com>
	<52E478A4.2030109@huawei.com>
	<20140127150722.ec1bb078cd4ae18f44ece9ae@linux-foundation.org>
Message-ID: <52E7018D.2080009@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/1/28 7:07, Andrew Morton wrote:
> On Sun, 26 Jan 2014 10:53:24 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
> 
>> Hi
>>
>> On 2014/1/25 4:47, akpm at linux-foundation.org wrote:
>>> From: Zongxun Wang <wangzongxun@huawei.com>
>>> Subject: ocfs2: free allocated clusters if error occurs after ocfs2_claim_clusters
>>>
>>> Even if using the same jbd2 handle, we cannot rollback a transaction.  So
>>> once some error occurs after successfully allocating clusters, the
>>> allocated clusters will never be used and it means they are lost.  For
>>> example, call ocfs2_claim_clusters successfully when expanding a file, but
>>> failed in ocfs2_insert_extent.  So we need free the allocated clusters if
>>> they are not used indeed.
>>>
>>
>> We should note down num of bits to be freed, so as to update i_used
>> correspondingly after clearing those bits in bitmap.
>> I sent a patch based on this:
>> [PATCH] ocfs2: correctly update i_used in	ocfs2_free_local_alloc_bits
>> https://oss.oracle.com/pipermail/ocfs2-devel/2013-November/009462.html
> 
> OK thanks, I now have that, as
> ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
> 
> Do we think that
> ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch
> and
> ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
> should now be merged upstream?
> 
> 
> .
> 
Could Mark & Joel review the two patches? Thanks.
