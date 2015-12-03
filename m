From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 3 Dec 2015 12:36:24 +0800
Subject: [Ocfs2-devel] Why not utilize ignore_higher to reduce assert
	master work
In-Reply-To: <565EA6D4.7080109@huawei.com>
References: <565EA6D4.7080109@huawei.com>
Message-ID: <565FC6C8.6060607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/02/2015 04:07 PM, Xue jiufei wrote:
> Hi all,
> We found that there may exist lots of assert_master works which seriously
> delayed other works. Function dlm_assert_master_worker() can ignore the
> node which is higher than master node. But ignore_higher is always
> set to 0. So why not utilize this value to reduce assert_master work?
> I think dlm_master_request_handler() can set ignore_higher to 1 when call
> dlm_dispatch_assert_master(). Will this introduce other problems?
Looks OK. Master request is sent from lowest node to master node, when
master nodes assert the master, it only needs clear the mle on lower
nodes. But please do full test in case export some bug.

Thanks,
Junxiao.
> 
> Thanks,
> Xuejiufei
> 
