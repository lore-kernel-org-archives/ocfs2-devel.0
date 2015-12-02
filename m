From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 2 Dec 2015 16:07:48 +0800
Subject: [Ocfs2-devel] Why not utilize ignore_higher to reduce assert master
	work
Message-ID: <565EA6D4.7080109@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
We found that there may exist lots of assert_master works which seriously
delayed other works. Function dlm_assert_master_worker() can ignore the
node which is higher than master node. But ignore_higher is always
set to 0. So why not utilize this value to reduce assert_master work?
I think dlm_master_request_handler() can set ignore_higher to 1 when call
dlm_dispatch_assert_master(). Will this introduce other problems?

Thanks,
Xuejiufei
