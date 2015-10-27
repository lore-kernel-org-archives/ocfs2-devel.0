From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Tue, 27 Oct 2015 08:32:39 -0400
Subject: [Ocfs2-devel] [PATCH v3 0/7] Inode security label invalidation
In-Reply-To: <1445894128-6765-1-git-send-email-agruenba@redhat.com>
References: <1445894128-6765-1-git-send-email-agruenba@redhat.com>
Message-ID: <562F6EE7.2090601@tycho.nsa.gov>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, ocfs2-devel@oss.oracle.com

On 10/26/2015 05:15 PM, Andreas Gruenbacher wrote:
> Here is another version of the patch queue to make gfs2 and similar file
> systems work with SELinux.  As suggested by Stephen Smalley [*], the relevant
> uses of inode->security are wrapped in function calls that try to revalidate
> invalid labels.
>
>    [*] http://marc.info/?l=linux-kernel&m=144416710207686&w=2
>
> The patches are looking good from my point of view; is there anything else that
> needs addressing?
>
> Does SELinux have test suites that these patches could be tested agains?

git clone https://github.com/SELinuxProject/selinux-testsuite
sudo yum install perl-Test perl-Test-Harness selinux-policy-devel gcc 
libselinux-devel net-tools netlabel_tools iptables
cd selinux-testsuite
sudo make test

>
> Thanks,
> Andreas
>
> Andreas Gruenbacher (7):
>    selinux: Remove unused variable in selinux_inode_init_security
>    selinux: Add accessor functions for inode->i_security
>    selinux: Get rid of file_path_has_perm
>    selinux: Push dentry down from {dentry,path,file}_has_perm
>    security: Add hook to invalidate inode security labels
>    selinux: Revalidate invalid inode security labels
>    gfs2: Invalide security labels of inodes when they go invalid
>
>   fs/gfs2/glops.c                   |   2 +
>   include/linux/lsm_hooks.h         |   6 ++
>   include/linux/security.h          |   5 +
>   security/security.c               |   8 ++
>   security/selinux/hooks.c          | 213 ++++++++++++++++++++++----------------
>   security/selinux/include/objsec.h |   6 ++
>   6 files changed, 152 insertions(+), 88 deletions(-)
>
