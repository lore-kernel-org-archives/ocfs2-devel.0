From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 23 Feb 2013 12:22:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_init_security_and_acl()
 to initialize acl correctly
In-Reply-To: <20130222183103.1342e7a3.akpm@linux-foundation.org>
References: <51275362.8020104@oracle.com>
	<20130222132140.0e093dfd.akpm@linux-foundation.org>
	<5128257A.8010103@oracle.com>
	<20130222183103.1342e7a3.akpm@linux-foundation.org>
Message-ID: <51284410.2020105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 02/23/2013 10:31 AM, Andrew Morton wrote:
> On Sat, 23 Feb 2013 10:12:10 +0800 Jeff Liu <jeff.liu@oracle.com> wrote:
> 
>> Hi Andrew,
>>
>> On 02/23/2013 05:21 AM, Andrew Morton wrote:
>>> On Fri, 22 Feb 2013 19:15:46 +0800
>>> Jeff Liu <jeff.liu@oracle.com> wrote:
>>>
>>>> We need to re-initialize the security if it isn't preserved for ocfs2_reflink().
>>>> however, the code logic is broken at ocfs2_init_security_and_acl() although
>>>> ocfs2_init_security_get() succeed, as a result, ocfs2_acl_init() does not involked.
>>>
>>> When writing a changelog, please describe the end-user-visible effects
>>> of the bug, so that others can more easily decide which kernel
>>> version(s) should be fixed, and so that downstream kernel maintainers
>>> can more easily work out whether this patch will fix a problem which
>>> they or their customers are observing.
>> Thanks for your teaching, I'll take care of it next time.
>>
> 
> Well OK, but please provide this info for this particular patch!  I
> still don't know if we should backport it into -stable kernels.

Could you please check the following revised changelog?

We need to re-initialize the security for a new reflinked inode with it's parent
dirs if it isn't specified to be preserved for ocfs2_reflink().  However, the code
logic is broken at ocfs2_init_security_and_acl() although ocfs2_init_security_get()
succeed.  As a result, ocfs2_acl_init() does not involked and therefore the default
ACL of parent dir was missing on the new inode.

Note this was introduced by 9d8f13ba3 ("security: new security_inode_init_security API adds function callback")

To reproduce:

set default ACL for the parent dir(ocfs2 in this case):
$ setfacl -m default:user:jeff:rwx ../ocfs2/
$ getfacl ../ocfs2/
# file: ../ocfs2/
# owner: jeff
# group: jeff
user::rwx
group::r-x
other::r-x
default:user::rwx
default:user:jeff:rwx
default:group::r-x
default:mask::rwx
default:other::r-x

$ touch a
$ getfacl a
# file: a
# owner: jeff
# group: jeff
user::rw-
group::rw-
other::r--

Before patching, create reflink file b from a, the user
default ACL entry(user:jeff:rwx)was missing:
$ ./ocfs2_reflink a b
$ getfacl b
# file: b
# owner: jeff
# group: jeff
user::rw-
group::rw-
other::r--

In this case, the end user can also observed an error message at syslog:
(ocfs2_reflink,3229,2):ocfs2_init_security_and_acl:7193 ERROR: status = 0

After applying this patch, create reflink file c from a:
$ ./ocfs2_reflink a c
$ getfacl c
# file: c
# owner: jeff
# group: jeff
user::rw-
user:jeff:rwx			#effective:rw-
group::r-x			#effective:r--
mask::rw-
other::r--

Test program:
/* Usage: reflink <source> <dest> */
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>

static int
reflink_file(char const *src_name, char const *dst_name,
	     bool preserve_attrs)
{
	int fd;

#ifndef REFLINK_ATTR_NONE
#  define REFLINK_ATTR_NONE 0
#endif
#ifndef REFLINK_ATTR_PRESERVE
#  define REFLINK_ATTR_PRESERVE 1
#endif
#ifndef OCFS2_IOC_REFLINK
	struct reflink_arguments {
		uint64_t old_path;
		uint64_t new_path;
		uint64_t preserve;
	};

#  define OCFS2_IOC_REFLINK _IOW ('o', 4, struct reflink_arguments)
#endif
	struct reflink_arguments args = {
		.old_path = (unsigned long) src_name,
		.new_path = (unsigned long) dst_name,
		.preserve = preserve_attrs ? REFLINK_ATTR_PRESERVE :
					     REFLINK_ATTR_NONE,
	};

	fd = open(src_name, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "Failed to open %s: %s\n",
			src_name, strerror(errno));
		return -1;
	}

	if (ioctl(fd, OCFS2_IOC_REFLINK, &args) < 0) {
		fprintf(stderr, "Failed to reflink %s to %s: %s\n",
			src_name, dst_name, strerror(errno));
		return -1;
	}
}

int
main(int argc, char *argv[])
{
	if (argc != 3) {
		fprintf(stdout, "Usage: %s source dest\n", argv[0]);
		return 1;
	}

	return reflink_file(argv[1], argv[2], 0);
}


 

Thanks for your time!

-Jeff
