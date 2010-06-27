From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Sun, 27 Jun 2010 13:33:02 -0700
Subject: [Ocfs2-devel] libdlm_lt.so vs. libdlm_lt.so.3
Message-ID: <AANLkTilaQlW3H_24fwrKbMHrBhk-rWv7_4jWr12e4RzL@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have spent the weekend assembling a small OCFS2 cluster, under the
Pacemaker cluster stack, using nothing but Debian experimental
packages.

I found a few problems along the way -- and I have reported them as
bugs to the Debian maintainers -- but I do have it all working now.

The final problem I encountered was this one:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=587287

Briefly, mkfs.ocfs2 was bombing out with "Unable to access cluster
service while initializing the dlm".  This ultimately comes from lines
716-720 in ocfs2-tools-1.4.4/libo2dlm/o2dlm.c:

        ctxt->ct_lib_handle = dlopen("libdlm_lt.so",
                                     RTLD_NOW | RTLD_LOCAL);
        if (!ctxt->ct_lib_handle)
                goto out;

On Debian, ".so" symlinks are included in development ("-dev")
packages, not in production packages.  This is because they are
normally only used at compile time, not at run time; the compiler
always includes the major number for the dependency in the executable.
 (To see what I mean, run "ldd" on just about any executable; you will
find lots of dependencies on libfoo.so.N, but none on libfoo.so.)

I could submit this as a bug against the Debian redhat-cluster
package, asking them to move the libdlm_lt.so symlink from the
libdlm-dev package to the libdlm3 package.  But I do not actually
think that would be correct.  Just as "ldd /bin/cat" shows how cat
depends on libc.so.6 (not libc.so), in point of fact libo2dlm depends
on a particular major version of the libdlm_lt.so shared object (i.e.,
a particular major version of the binary API).

So, if I submit a patch changing the dlopen() in o2dlm.c to load
"libdlm_lt.so.3" instead of "libdlm_lt.so", will the OCFS2 maintainers
accept it?  If not, why not?

Thank you.

 - Pat
