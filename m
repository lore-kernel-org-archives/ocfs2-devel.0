From: Avi Kivity <avi@redhat.com>
Date: Tue, 16 Nov 2010 12:25:53 -0000
Subject: [Ocfs2-devel] [PATCH 4/6] Ext4: fail if we try to use hole punch
In-Reply-To: <1289840723-3056-5-git-send-email-josef@redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
Message-ID: <4CE2783F.1020004@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@redhat.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On 11/15/2010 07:05 PM, Josef Bacik wrote:
> Ext4 doesn't have the ability to punch holes yet, so make sure we return
> EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
> be added later.  Thanks,
>

Instead of teaching filesystems to fail if they don't support the 
capability, why don't supporting filesystems say so, allowing the fail 
code to be in common code?

-- 
error compiling committee.c: too many arguments to function
