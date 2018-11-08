From: piaojun <piaojun@huawei.com>
Date: Thu, 8 Nov 2018 09:57:28 +0800
Subject: [Ocfs2-devel] [RFC PATCH 0/5] ocfs2: support IPv6 communication
	in o2cb cluster
In-Reply-To: <20181107145654.151723a2fe9a44e9c7e3a8de@linux-foundation.org>
References: <5BD19B73.7050607@huawei.com>
	<20181107145654.151723a2fe9a44e9c7e3a8de@linux-foundation.org>
Message-ID: <5BE39808.5080205@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 2018/11/8 6:56, Andrew Morton wrote:
> On Thu, 25 Oct 2018 18:31:15 +0800 piaojun <piaojun@huawei.com> wrote:
> 
>> o2cb cluster only support IPv4 node configuration nowadays. Along with IPv6
>> used more widely, ocfs2 should also keep up with the pace. This patch
>> series add configfs attribute for IPv6 configure and build connnection
>> between nodes with IPv6 socket. So the nodes in cluster could send dlm
>> messages through IPv6 network protocol.
> 
> Big patchset.  I'll await some reviewer input before looking at merging
> this, I think.
> 
> Please update Documentation/filesystems/ocfs2.txt to document all the
> new userspace interfaces and the overall feature, etc.

OK, there is some work in userspace, such as o2cb_ctl, and I will add
another patch to update the document.
> 
> Should the new code be hidden behind `#ifdef CONFIG_IPV6'?  That would
> avoid some code bloat.
> 
> (That being said, if ocfs2 was concerned about code bloat, it would do
> something about the fact that mlog() and mlog_errno() more than double
> the file system's object code size).

Good suggestion, and I will consider using CONFIG_IPV6 to make code
thiner.

Thanks,
Jun
> 
> .
> 
