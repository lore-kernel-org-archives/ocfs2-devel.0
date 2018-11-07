From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Nov 2018 14:56:54 -0800
Subject: [Ocfs2-devel] [RFC PATCH 0/5] ocfs2: support IPv6 communication
 in o2cb cluster
In-Reply-To: <5BD19B73.7050607@huawei.com>
References: <5BD19B73.7050607@huawei.com>
Message-ID: <20181107145654.151723a2fe9a44e9c7e3a8de@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 25 Oct 2018 18:31:15 +0800 piaojun <piaojun@huawei.com> wrote:

> o2cb cluster only support IPv4 node configuration nowadays. Along with IPv6
> used more widely, ocfs2 should also keep up with the pace. This patch
> series add configfs attribute for IPv6 configure and build connnection
> between nodes with IPv6 socket. So the nodes in cluster could send dlm
> messages through IPv6 network protocol.

Big patchset.  I'll await some reviewer input before looking at merging
this, I think.

Please update Documentation/filesystems/ocfs2.txt to document all the
new userspace interfaces and the overall feature, etc.

Should the new code be hidden behind `#ifdef CONFIG_IPV6'?  That would
avoid some code bloat.

(That being said, if ocfs2 was concerned about code bloat, it would do
something about the fact that mlog() and mlog_errno() more than double
the file system's object code size).
