From: Germano Percossi <germano.percossi@citrix.com>
Date: Tue, 9 Dec 2014 19:32:28 +0000
Subject: [Ocfs2-devel] ocfs2-tools repository and documentation
Message-ID: <54874E4C.8040006@citrix.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Sorry if this has been asked in the past but I did not
find anything in the archive.

It is not very clear to me where are the most up-to-date
ocfs-tools repository (both source code and
packages) and documentation.

For development I am looking at 
https://oss.oracle.com/git/?p=ocfs2-tools.git;a=summary but the most 
recent commit seems to be more than
1 year old.

I found an RPM (asking a colleague of mine to ask one of his contacts
in Oracle) here 
http://public-yum.oracle.com/repo/OracleLinux/OL7/0/base/x86_64/getPackageSource/ocfs2-tools-1.8.0-16.el7.src.rpm.
When I inspected the content I found, comparing it to another package we
have, the following:
- a spec file (ok)
- some patches (ok)
- a tar.gz (ok but..)

The tar.gz is ocfs2-tools-1.8.0.tar.gz. The first strange thing is
that there are no versions tagged 1.8.0 in the git repo I am watching.
The other thing is, in our old RPM we have a tar.gz with the same name.
When I compared the content I found they differ just for the
vendor/rhel7 directory. Its content though is not in the git repository.

Is this repository the right one?

Similar doubts apply to documentation (referring to 1.6 version of the
tools and subversion as repository) and RPM repositories.

Would you please point me to the right development resources?

Thanks you,
Germano
