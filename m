From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Date: Mon, 23 Mar 2015 08:56:04 -0400
Subject: [Ocfs2-devel] CAP_SYS_ADMIN capability check for
	ocfs2_xattr_trusted_list
Message-ID: <CADa969jYEktr=anV2r4djrLwhiupR3UTN214UH0jfDLraqEEyQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

In the ocfs2_xattr_trusted_list function, there is no check for
CAP_SYS_ADMIN whereas the man page explains that list should be
accessible only to the processes that have this capability enabled.

It would be great if you can tell whether there is a particular reason
for not having the check?

Thanks,
Sanidhya
