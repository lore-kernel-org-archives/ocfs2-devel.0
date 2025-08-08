Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41210367
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 Aug 2025 04:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754625789; cv=none; b=oFs/6E23OFAhrT5oYfAbhpNKak1ZMm44jnXJ8/GN94gKuzcN0wbTHsVB87MWg/YzIRv6yJs8/AEbxr7dQfS/+0FTIyrOKO+p7ul27PWgmOpaGjb+rTFKTp+G0DHsbk2PiZo6wfiri5bG5Lhg6mC1+/ZzrqbeBULYpjWTes2+TdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754625789; c=relaxed/simple;
	bh=z+FX6wd8PiU1OSnf1oflidkDWViJKJ/JHtDaaUhNGPI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=jLxcVlDwnsFash1ffrvjHcNJR9FIfBMNFc5Yf9fhU/zmAXhOuDwU3GxGKw/nczkcb4FgdEDKlMu2ew4AsFekVxdeO5J2zaCjXCA7rvsTb0wKHajVwWAKdZFHQYGP8O5YStDFh4oXozM4EPS4pcMcEAeiU5YSggg6HO+3hEhLoQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=anP3xidO; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="anP3xidO"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e903e1cb1bfso1199076276.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 07 Aug 2025 21:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754625785; x=1755230585; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z+FX6wd8PiU1OSnf1oflidkDWViJKJ/JHtDaaUhNGPI=;
        b=anP3xidObTybu1Ry6Jpag31oB4EXeRFDq3NOamMNvXqaCFpkpCJ+JyvvBsoHy/BZ0B
         IvXPmTMfRUxuQbLSYVTNJ/43YgQgS8vkFWA99cCNQ19bP5jGgbUXdH/EFWS8UTGTqxIY
         3cSnQWh6Bea/tjuVx4qiN6sFDy2jEKse9AJ1U8uVAJsvyMPMOoFI5Dm+8xOCgHExENZD
         fTLtFRc+wflFQMdTuoHEqSD/XfsDpMxsVQJVqfL7hAQ7s+0kPM2rldomkbwzgXXqLjPG
         W91DMAql0m4egLB1cCB7NTuxKE9SfwWVm42/apjuEZ2Fm1WU8yuojotKDICxpuX2qGmC
         njVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754625785; x=1755230585;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z+FX6wd8PiU1OSnf1oflidkDWViJKJ/JHtDaaUhNGPI=;
        b=PD+lgbWLqWCOJMxa8E/l1w8W0XNKOUcpzbMPi3tWMmUNk5WUnle/5lYdqNUjCOELF6
         oOIvIm16bf9kzDfua1SWqf3fTBmF8daIFK8WNov3Q3PnQkifWaQ3LP+WOVWhKzOQ2rzf
         OmXLmzFRHgFuj3m9BYLOoWB7IYYNLcIEQofiCt+qglAsAEwKlnBWxQsrEEAa09dWeEke
         BVaop420zOkKW00DzRM/haKvheVAJzkMgFYbaYlnJ4u9+u6LaeqrcMS5H9lzQkc8UUjY
         1YqhmHGaz10yjMSIGy8L5fA85OpevR19pjgehyybbMPapE406qM6JvU2VEMGNzrOnbyA
         l8eg==
X-Forwarded-Encrypted: i=1; AJvYcCUoBOhih/KxJU751ay68y6Jk5zdAH2tnvoDwDzYz/BpydXYO7JTpxhVWUaIJIDx8K+e85InxBI3MKJJpA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzN9iarSQmmmm6S9HpK/N/PZyiZqqgZyIrlRt8v2xADcoDG/W82
	pdWJTRRE+KQW4edyKgqr8Z64YPrXL2vPeL+dk1mKkltGH1LRmoTGWeE8+4E/k5BXDMx2X8tvc9E
	8GlXlxD6tQNfveEShhn+MU2zTr472sZg=
X-Gm-Gg: ASbGncuMemBdnjcEsAVZ76lkLS4cS7zm7MpcyuxMhEUoEPrWq2xkP77SU1ls+cQ/gFe
	f25rjDFUDsTURCqEC6V3j50dZjyA9zGMnbFdZQypshedBVNvhTptq+Ctc8733F5kdDHR0+YxoRN
	L3k2QPE+wcUBfiwyax8tnp7ytwo6xT+/GqDTusTTse+krLhCcPv2NlNadhvKAwOyshTVErSDt/w
	US25T2MqupOa7kBBUwr3TIW6qMH6KfyJgwI7Yj4F9pmA1iIVQgq
X-Google-Smtp-Source: AGHT+IH9mwir5OzMq0JpRI2i1C3gYMRaLPhsVKhSSgUy3oaRM3RmyuQXphLX7I/7iXDHZcCDTNvl7jGoZ6OKXouXctk=
X-Received: by 2002:a05:690c:7006:b0:71a:30c4:43da with SMTP id
 00721157ae682-71bdaf5c672mr75691697b3.13.1754625784850; Thu, 07 Aug 2025
 21:03:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: yes PANG <pangyes608@gmail.com>
Date: Fri, 8 Aug 2025 12:02:52 +0800
X-Gm-Features: Ac12FXz9fY12ZDnKgEuGrHD4oNRl6-XQL-taumxs5-Zg-Il-8h85kcI35n1sHuI
Message-ID: <CAJLDUOcyfT=JvBpwKr4UCZb+eq30QL3+PswWPBPnUpQn0kkHcw@mail.gmail.com>
Subject: kernel BUG in __ocfs2_flush_truncate_log
To: "mark@fasheh.com" <mark@fasheh.com>, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000009f3bc0063bd2a6d5"

--0000000000009f3bc0063bd2a6d5
Content-Type: multipart/alternative; boundary="0000000000009f3bbe063bd2a6d3"

--0000000000009f3bbe063bd2a6d3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Linux maintainers and reviewers:
We are reporting a Linux kernel bug titled **kernel BUG in
__ocfs2_flush_truncate_log**, discovered using a modified version of
Syzkaller.
Following my previous bug report, here is a structured analysis from our
fault localization tool "CoHIKER". These may be helpful for your fixing and
patches.
**root cause analysis**
Core Fault:
Invalid truncate log state handling during OCFS2 filesystem sync
operations, specifically in the truncate log flush path (fs/ocfs2/alloc.c).

Trigger Conditions:
Mounting OCFS2 with specific vulnerable configuration:
 Mount flags =3D 0x0
 Quota command =3D 0x80000800
 Memory protection =3D 0x1
Subsequent file operations
Truncate log flush during sync/unmount

Failure Mechanism:
The combination of these configurations creates inconsistent truncate log
states that aren't properly handled during flush operations,
leading to a kernel BUG when the system attempts to synchronize filesystem
metadata.

Evidence from Mutations:
Successful mutations all modified operational parameters:
Changing quota command (0x80000800=E2=86=920x80000801)
Adjusting memory protection (0x1=E2=86=920x4)
Modifying mount flags (0x0=E2=86=920x1)
Failed mutation (mount flags 0x0=E2=86=920x3) confirmed the bug is
configuration-sensitive

Impact Scope:
Subsystem: OCFS2 filesystem implementation
Component: Truncate log management subsystem
Phase: Sync operations (particularly metadata flush)

Root Cause Conclusion:
The bug manifests due to insufficient validation of truncate log state
transitions when OCFS2 is configured with specific non-default parameters,
combined with particular sequences of filesystem operations. The invalid
state isn't detected until sync phase, causing a fatal kernel error during
metadata flushing.

**result of file and method level fault localization"
Top-10 of the buggy file:
1. fs/ocfs2/alloc.c
2. fs/ocfs2/journal.c
3. fs/ocfs2/dlmglue.c
4. fs/ocfs2/super.c
5. fs/ocfs2/alloc.h
6. fs/ocfs2/ocfs2_fs.h
7. fs/ocfs2/file.c
8. fs/ocfs2/inode.c
9. fs/ocfs2/aops.c
10. fs/ocfs2/dlm/dlmcommon.h
Top-10 of the buggy method:
1.__ocfs2_flush_truncate_log
2. ocfs2_flush_truncate_log
3. ocfs2_free_cached_clusters
4. ocfs2_run_deallocs
5. ocfs2_cache_cluster_dealloc
6. ocfs2_cache_block_dealloc
7. ocfs2_commit_truncate
8. ocfs2_free_cached_blocks
9. ocfs2_truncate_log_append
10. ocfs2_remove_extent
Attached:
complete output of fault localizaiton

--0000000000009f3bbe063bd2a6d3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Dear Linux maintainers and reviewers:<br>We are reporting =
a Linux kernel bug titled **kernel BUG in __ocfs2_flush_truncate_log**, dis=
covered using a modified version of Syzkaller.<br>Following my previous bug=
 report, here is a structured analysis from our fault localization tool &qu=
ot;CoHIKER&quot;. These may be helpful for your fixing and patches.<br>**ro=
ot cause analysis**<br>Core Fault:<br>Invalid truncate log state handling d=
uring OCFS2 filesystem sync operations, specifically in the truncate log fl=
ush path (fs/ocfs2/alloc.c).<br><br>Trigger Conditions:<br>Mounting OCFS2 w=
ith specific vulnerable configuration:<br>=C2=A0Mount flags =3D 0x0<br>=C2=
=A0Quota command =3D 0x80000800<br>=C2=A0Memory protection =3D 0x1<br>Subse=
quent file operations<br>Truncate log flush during sync/unmount<br><br>Fail=
ure Mechanism:<br>The combination of these configurations creates inconsist=
ent truncate log states that aren&#39;t properly handled during flush opera=
tions, <br>leading to a kernel BUG when the system attempts to synchronize =
filesystem metadata.<br><br>Evidence from Mutations:<br>Successful mutation=
s all modified operational parameters:<br>Changing quota command (0x8000080=
0=E2=86=920x80000801)<br>Adjusting memory protection (0x1=E2=86=920x4)<br>M=
odifying mount flags (0x0=E2=86=920x1)<br>Failed mutation (mount flags 0x0=
=E2=86=920x3) confirmed the bug is configuration-sensitive<br><br>Impact Sc=
ope:<br>Subsystem: OCFS2 filesystem implementation<br>Component: Truncate l=
og management subsystem<br>Phase: Sync operations (particularly metadata fl=
ush)<br><br>Root Cause Conclusion:<br>The bug manifests due to insufficient=
 validation of truncate log state transitions when OCFS2 is configured with=
 specific non-default parameters, <br>combined with particular sequences of=
 filesystem operations. The invalid state isn&#39;t detected until sync pha=
se, causing a fatal kernel error during metadata flushing.<br><br>**result =
of file and method level fault localization&quot;<br>Top-10 of the buggy fi=
le:<br>1. fs/ocfs2/alloc.c<br>2. fs/ocfs2/journal.c<br>3. fs/ocfs2/dlmglue.=
c<br>4. fs/ocfs2/super.c<br>5. fs/ocfs2/alloc.h<br>6. fs/ocfs2/ocfs2_fs.h<b=
r>7. fs/ocfs2/file.c<br>8. fs/ocfs2/inode.c<br>9. fs/ocfs2/aops.c<br>10. fs=
/ocfs2/dlm/dlmcommon.h<br>Top-10 of the buggy method:<br>1.__ocfs2_flush_tr=
uncate_log<br>2. ocfs2_flush_truncate_log<br>3. ocfs2_free_cached_clusters<=
br>4. ocfs2_run_deallocs<br>5. ocfs2_cache_cluster_dealloc<br>6. ocfs2_cach=
e_block_dealloc<br>7. ocfs2_commit_truncate<br>8. ocfs2_free_cached_blocks<=
br>9. ocfs2_truncate_log_append<br>10. ocfs2_remove_extent<br>Attached: <br=
>complete output of fault localizaiton</div>

--0000000000009f3bbe063bd2a6d3--
--0000000000009f3bc0063bd2a6d5
Content-Type: text/plain; charset="UTF-8"; name="complete_output.txt"
Content-Disposition: attachment; filename="complete_output.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_me2avmr40>
X-Attachment-Id: f_me2avmr40

RmlsZS1sZXZlbCBvdXRwdXQ6DQp7DQogICJ0aG91Z2h0X3Byb2Nlc3MiOiB7DQogICAgInN0ZXAx
Ijogew0KICAgICAgImJ1Z19sb2NhdGlvbiI6ICJmcy9vY2ZzMi9hbGxvYy5jIGxpbmUgNjAxOSBp
biBfX29jZnMyX2ZsdXNoX3RydW5jYXRlX2xvZygpIiwNCiAgICAgICJidWdfdHlwZSI6ICJLZXJu
ZWwgQlVHIChpbnZhbGlkIG9wY29kZSkgc3VnZ2VzdGluZyBmaWxlc3lzdGVtIG1ldGFkYXRhIGNv
cnJ1cHRpb24gZHVyaW5nIHRydW5jYXRlIGxvZyBvcGVyYXRpb25zIiwNCiAgICAgICJtb2R1bGUi
OiAiT0NGUzIgZmlsZXN5c3RlbSIsDQogICAgICAidHJpZ2dlcl9vcGVyYXRpb24iOiAiVHJ1bmNh
dGUgbG9nIGZsdXNoaW5nIGR1cmluZyBmaWxlc3lzdGVtIHN5bmMvdW5tb3VudCINCiAgICB9LA0K
ICAgICJzdGVwMiI6IHsNCiAgICAgICJ0ZXN0X3Byb2dyYW1fYW5hbHlzaXMiOiB7DQogICAgICAg
ICJzeXNjYWxscyI6IFsNCiAgICAgICAgICAicXVvdGFjdGwkUV9TRVRRVU9UQTogU2V0cyBkaXNr
IHF1b3RhIHBhcmFtZXRlcnMiLA0KICAgICAgICAgICJwa2V5X21wcm90ZWN0OiBNb2RpZmllcyBt
ZW1vcnkgcHJvdGVjdGlvbnMiLA0KICAgICAgICAgICJzeXpfbW91bnRfaW1hZ2Ukb2NmczI6IE1v
dW50cyBPQ0ZTMiBmaWxlc3lzdGVtIiwNCiAgICAgICAgICAib3BlbmF0K3dyaXRlOiBQZXJmb3Jt
cyBmaWxlIG9wZXJhdGlvbnMiDQogICAgICAgIF0sDQogICAgICAgICJ0ZXN0X2ZvY3VzIjogIk9D
RlMyIGZpbGVzeXN0ZW0gYmVoYXZpb3IgZHVyaW5nIHF1b3RhIHNldHVwIGFuZCBmaWxlIG9wZXJh
dGlvbnMiDQogICAgICB9DQogICAgfSwNCiAgICAic3RlcDMiOiB7DQogICAgICAic3VjY2Vzc2Z1
bF9tdXRhdGlvbnMiOiBbDQogICAgICAgIHsNCiAgICAgICAgICAibXV0YXRpb24iOiAicXVvdGFj
dGwgY21kIGNoYW5nZWQgZnJvbSAweDgwMDAwODAwIHRvIDB4ODAwMDA4MDEiLA0KICAgICAgICAg
ICJlZmZlY3QiOiAiQWx0ZXJzIHF1b3RhIG1hbmFnZW1lbnQgYmVoYXZpb3IsIHByZXZlbnRpbmcg
Y29ycnVwdCBzdGF0ZSINCiAgICAgICAgfSwNCiAgICAgICAgew0KICAgICAgICAgICJtdXRhdGlv
biI6ICJwa2V5X21wcm90ZWN0IHByb3QgY2hhbmdlZCBmcm9tIDB4MSB0byAweDQiLA0KICAgICAg
ICAgICJlZmZlY3QiOiAiQ2hhbmdlcyBtZW1vcnkgcHJvdGVjdGlvbiBmbGFncyBhZmZlY3Rpbmcg
ZmlsZXN5c3RlbSBvcGVyYXRpb25zIg0KICAgICAgICB9LA0KICAgICAgICB7DQogICAgICAgICAg
Im11dGF0aW9uIjogInN5el9tb3VudF9pbWFnZSBmbGFncyBjaGFuZ2VkIGZyb20gMHgwIHRvIDB4
MSIsDQogICAgICAgICAgImVmZmVjdCI6ICJNb2RpZmllcyBmaWxlc3lzdGVtIG1vdW50IG9wdGlv
bnMgcHJldmVudGluZyB0aGUgYnVnIg0KICAgICAgICB9DQogICAgICBdDQogICAgfSwNCiAgICAi
c3RlcDQiOiB7DQogICAgICAiZmFpbGVkX211dGF0aW9uIjogew0KICAgICAgICAibXV0YXRpb24i
OiAic3l6X21vdW50X2ltYWdlIGZsYWdzIGNoYW5nZWQgZnJvbSAweDAgdG8gMHgzIiwNCiAgICAg
ICAgImFuYWx5c2lzIjogIkNlcnRhaW4gbW91bnQgZmxhZyBjb21iaW5hdGlvbnMgc3RpbGwgdHJp
Z2dlciB0aGUgYnVnIg0KICAgICAgfQ0KICAgIH0sDQogICAgInN0ZXA1Ijogew0KICAgICAgImRl
ZmVjdF9jaGFyYWN0ZXJpc3RpY3MiOiBbDQogICAgICAgICJPQ0ZTMi1zcGVjaWZpYyB0cnVuY2F0
ZSBsb2cgaGFuZGxpbmcgaXNzdWUiLA0KICAgICAgICAiVHJpZ2dlcmVkIGR1cmluZyBmaWxlc3lz
dGVtIHN5bmMvdW5tb3VudCBwYXRoIiwNCiAgICAgICAgIlNlbnNpdGl2ZSB0byBtb3VudCBvcHRp
b25zIGFuZCBxdW90YSBzZXR0aW5ncyIsDQogICAgICAgICJSZWxhdGVkIHRvIG1ldGFkYXRhIG1h
bmFnZW1lbnQiDQogICAgICBdDQogICAgfSwNCiAgICAic3RlcDYiOiB7DQogICAgICAiZmlsZV9j
bGFzc2lmaWNhdGlvbiI6IHsNCiAgICAgICAgImNvcmVfb2NmczIiOiBbDQogICAgICAgICAgImZz
L29jZnMyL2FsbG9jLmMiLA0KICAgICAgICAgICJmcy9vY2ZzMi9zdXBlci5jIiwNCiAgICAgICAg
ICAiZnMvb2NmczIvam91cm5hbC5jIg0KICAgICAgICBdLA0KICAgICAgICAibWV0YWRhdGFfaGFu
ZGxpbmciOiBbDQogICAgICAgICAgImZzL29jZnMyL2FsbG9jLmgiLA0KICAgICAgICAgICJmcy9v
Y2ZzMi9vY2ZzMl9mcy5oIiwNCiAgICAgICAgICAiZnMvb2NmczIvZGxtZ2x1ZS5jIg0KICAgICAg
ICBdLA0KICAgICAgICAiZmlsZXN5c3RlbV9vcHMiOiBbDQogICAgICAgICAgImZzL29jZnMyL2Zp
bGUuYyIsDQogICAgICAgICAgImZzL29jZnMyL2lub2RlLmMiLA0KICAgICAgICAgICJmcy9vY2Zz
Mi9hb3BzLmMiDQogICAgICAgIF0sDQogICAgICAgICJjbHVzdGVyX21hbmFnZW1lbnQiOiBbDQog
ICAgICAgICAgImZzL29jZnMyL2RsbS9kbG1jb21tb24uaCIsDQogICAgICAgICAgImZzL29jZnMy
L2NsdXN0ZXIvbm9kZW1hbmFnZXIuaCINCiAgICAgICAgXQ0KICAgICAgfQ0KICAgIH0sDQogICAg
InN0ZXA3Ijogew0KICAgICAgImZhdWx0X2ZpbGVfY2hhcmFjdGVyaXN0aWNzIjogWw0KICAgICAg
ICAiSGFuZGxlcyB0cnVuY2F0ZSBsb2cgb3BlcmF0aW9ucyIsDQogICAgICAgICJNYW5hZ2VzIGZp
bGVzeXN0ZW0gbWV0YWRhdGEiLA0KICAgICAgICAiSW50ZXJhY3RzIHdpdGggbW91bnQgb3B0aW9u
cyIsDQogICAgICAgICJDb250YWlucyBPQ0ZTMi1zcGVjaWZpYyBhbGxvY2F0aW9uIGxvZ2ljIg0K
ICAgICAgXQ0KICAgIH0NCiAgfSwNCiAgInN0YW5kYXJkX291dHB1dCI6IFsNCiAgICAiZnMvb2Nm
czIvYWxsb2MuYyIsDQogICAgImZzL29jZnMyL2pvdXJuYWwuYyIsDQogICAgImZzL29jZnMyL2Rs
bWdsdWUuYyIsDQogICAgImZzL29jZnMyL3N1cGVyLmMiLA0KICAgICJmcy9vY2ZzMi9hbGxvYy5o
IiwNCiAgICAiZnMvb2NmczIvb2NmczJfZnMuaCIsDQogICAgImZzL29jZnMyL2ZpbGUuYyIsDQog
ICAgImZzL29jZnMyL2lub2RlLmMiLA0KICAgICJmcy9vY2ZzMi9hb3BzLmMiLA0KICAgICJmcy9v
Y2ZzMi9kbG0vZGxtY29tbW9uLmgiDQogIF0NCn0NCk1ldGhvZC1sZXZlbCBvdXRwdXQ6DQp7DQog
ICJ0aG91Z2h0X3Byb2Nlc3MiOiB7DQogICAgInN0ZXBfMSI6IHsNCiAgICAgICJkZXNjcmlwdGlv
biI6ICJCdWcgVW5kZXJzdGFuZGluZyIsDQogICAgICAiZGV0YWlscyI6ICJUaGUgYnVnIG9jY3Vy
cyBpbiBfX29jZnMyX2ZsdXNoX3RydW5jYXRlX2xvZyBhdCBmcy9vY2ZzMi9hbGxvYy5jOjYwMTks
IGluZGljYXRpbmcgYSBrZXJuZWwgQlVHIGR1cmluZyB0cnVuY2F0ZSBsb2cgZmx1c2hpbmcuIFRo
ZSBjcmFzaCBoYXBwZW5zIGR1cmluZyBmaWxlc3lzdGVtIHN5bmMgb3BlcmF0aW9ucyAob2NmczJf
c3luY19mcyDihpIgb2NmczJfZmx1c2hfdHJ1bmNhdGVfbG9nIOKGkiBfX29jZnMyX2ZsdXNoX3Ry
dW5jYXRlX2xvZykuIFRoaXMgaXMgY2xlYXJseSBpbiB0aGUgT0NGUzIgZmlsZXN5c3RlbSBzdWJz
eXN0ZW0sIHNwZWNpZmljYWxseSBpbiBzcGFjZSBtYW5hZ2VtZW50IGR1cmluZyBjbGVhbnVwIG9w
ZXJhdGlvbnMuIg0KICAgIH0sDQogICAgInN0ZXBfMiI6IHsNCiAgICAgICJkZXNjcmlwdGlvbiI6
ICJQcm9ncmFtIEludGVudGlvbiIsDQogICAgICAiZGV0YWlscyI6ICJUaGUgdGVzdCBwcm9ncmFt
IHBlcmZvcm1zOiAxKSBxdW90YSBzZXR1cCwgMikgbWVtb3J5IHByb3RlY3Rpb24sIDMpIE9DRlMy
IG1vdW50LCA0KSBmaWxlIGNyZWF0aW9uL3dyaXRlLiBUaGUgY3Jhc2ggb2NjdXJzIGR1cmluZyBz
eW5jIG9wZXJhdGlvbnMgYWZ0ZXIgd3JpdGluZywgc3VnZ2VzdGluZyB0aGUgYnVnIHJlbGF0ZXMg
dG8gcG9zdC13cml0ZSBjbGVhbnVwIGFuZCBzcGFjZSBtYW5hZ2VtZW50LiINCiAgICB9LA0KICAg
ICJzdGVwXzMiOiB7DQogICAgICAiZGVzY3JpcHRpb24iOiAiU3VjY2Vzc2Z1bCBNdXRhdGlvbiBB
bmFseXNpcyIsDQogICAgICAiZGV0YWlscyI6ICJObyBzdWNjZXNzZnVsIG11dGF0aW9ucyBwcm92
aWRlZCwgYnV0IHRoZSBjcmFzaCBjb250ZXh0IHN1Z2dlc3RzIHRoZSBidWcgbWFuaWZlc3RzIGR1
cmluZyB0cnVuY2F0ZSBsb2cgZmx1c2hpbmcgYWZ0ZXIgZmlsZSBvcGVyYXRpb25zLiINCiAgICB9
LA0KICAgICJzdGVwXzQiOiB7DQogICAgICAiZGVzY3JpcHRpb24iOiAiRmFpbGVkIE11dGF0aW9u
IEFuYWx5c2lzIiwNCiAgICAgICJkZXRhaWxzIjogIk5vIHNwZWNpZmljIGZhaWxlZCBtdXRhdGlv
bnMgcHJvdmlkZWQsIGJ1dCB0aGUgY29uc2lzdGVudCBjcmFzaCBwb2ludCBpbmRpY2F0ZXMgdGhl
IGlzc3VlIGlzIHJlbGlhYmx5IHRyaWdnZXJlZCBkdXJpbmcgdHJ1bmNhdGUgbG9nIG9wZXJhdGlv
bnMuIg0KICAgIH0sDQogICAgInN0ZXBfNSI6IHsNCiAgICAgICJkZXNjcmlwdGlvbiI6ICJEZWZl
Y3QgUGF0dGVybiBhbmQgTGlmZWN5Y2xlIEluZmVyZW5jZSIsDQogICAgICAiZGV0YWlscyI6ICJU
aGUgYnVnIG9jY3VycyBkdXJpbmcgY2xlYW51cCBwaGFzZSAodHJ1bmNhdGUgbG9nIGZsdXNoaW5n
KSwgc3VnZ2VzdGluZyBlaXRoZXI6IDEpIGluY29ycmVjdCBzdGF0ZSBkdXJpbmcgbG9nIGNyZWF0
aW9uL2FjY3VtdWxhdGlvbiwgMikgaW1wcm9wZXIgaGFuZGxpbmcgZHVyaW5nIGxvZyBmbHVzaCwg
b3IgMykgcmFjZSBiZXR3ZWVuIGxvZyBvcGVyYXRpb25zIGFuZCBvdGhlciBmaWxlc3lzdGVtIGFj
dGl2aXRpZXMuIg0KICAgIH0sDQogICAgInN0ZXBfNiI6IHsNCiAgICAgICJkZXNjcmlwdGlvbiI6
ICJGdW5jdGlvbiBDbGFzc2lmaWNhdGlvbiBhbmQgTWFwcGluZyIsDQogICAgICAiZGV0YWlscyI6
ICJGb2N1c2luZyBvbiBmdW5jdGlvbnMgcmVsYXRlZCB0byB0cnVuY2F0ZSBsb2cgbWFuYWdlbWVu
dCBhbmQgZXh0ZW50IG9wZXJhdGlvbnMgaW4gYWxsb2MuYywgcGFydGljdWxhcmx5IHRob3NlIGlu
dm9sdmVkIGluIGNsZWFudXAgcGhhc2VzLiBUaGUgY3Jhc2ggZnVuY3Rpb24gKF9fb2NmczJfZmx1
c2hfdHJ1bmNhdGVfbG9nKSBhbmQgaXRzIGNhbGxlciAob2NmczJfZmx1c2hfdHJ1bmNhdGVfbG9n
KSBhcmUgcHJpbWFyeSBzdXNwZWN0cywgYnV0IHVwc3RyZWFtIGZ1bmN0aW9ucyBtYW5hZ2luZyB0
aGUgbG9nIHN0YXRlIG1heSBhbHNvIGJlIGludm9sdmVkLiINCiAgICB9LA0KICAgICJzdGVwXzci
OiB7DQogICAgICAiZGVzY3JpcHRpb24iOiAiU3VzcGljaW9uIEluZmVyZW5jZSIsDQogICAgICAi
ZGV0YWlscyI6ICJUb3Agc3VzcGVjdHMgYXJlIGZ1bmN0aW9ucyBkaXJlY3RseSBpbnZvbHZlZCBp
biB0cnVuY2F0ZSBsb2cgbWFuYWdlbWVudCBhbmQgZXh0ZW50IGNsZWFudXAuIEZ1bmN0aW9ucyB0
aGF0IG1vZGlmeSB0aGUgdHJ1bmNhdGUgbG9nIHN0YXRlIGJlZm9yZSBmbHVzaGluZyBhcmUgYWxz
byBoaWdobHkgcmVsZXZhbnQsIGV2ZW4gaWYgbm90IGluIHRoZSBjcmFzaCB0cmFjZS4gSm91cm5h
bGluZyBmdW5jdGlvbnMgYXJlIGxlc3MgbGlrZWx5IHN1c3BlY3RzIGFzIHRoZSBjcmFzaCBvY2N1
cnMgZHVyaW5nIHNwYWNlIG1hbmFnZW1lbnQgcmF0aGVyIHRoYW4gdHJhbnNhY3Rpb24gaGFuZGxp
bmcuIg0KICAgIH0sDQogICAgInN0ZXBfOCI6IHsNCiAgICAgICJkZXNjcmlwdGlvbiI6ICJGaW5h
bCBPdXRwdXQiLA0KICAgICAgImRldGFpbHMiOiAiUmFua2VkIGxpc3QgcHJpb3JpdGl6ZXM6IDEp
IEZ1bmN0aW9ucyBkaXJlY3RseSBpbnZvbHZlZCBpbiB0aGUgY3Jhc2gsIDIpIFRoZWlyIGltbWVk
aWF0ZSBjYWxsZXJzLCAzKSBGdW5jdGlvbnMgdGhhdCBtYW5hZ2UgdHJ1bmNhdGUgbG9nIHN0YXRl
LCA0KSBGdW5jdGlvbnMgaGFuZGxpbmcgZXh0ZW50IGNsZWFudXAgdGhhdCBtaWdodCBhZmZlY3Qg
dGhlIGxvZyBjb250ZW50cy4iDQogICAgfQ0KICB9LA0KICAic3RhbmRhcmRfb3V0cHV0IjogWw0K
ICAgICJfX29jZnMyX2ZsdXNoX3RydW5jYXRlX2xvZyIsDQogICAgIm9jZnMyX2ZsdXNoX3RydW5j
YXRlX2xvZyIsDQogICAgIm9jZnMyX2ZyZWVfY2FjaGVkX2NsdXN0ZXJzIiwNCiAgICAib2NmczJf
cnVuX2RlYWxsb2NzIiwNCiAgICAib2NmczJfY2FjaGVfY2x1c3Rlcl9kZWFsbG9jIiwNCiAgICAi
b2NmczJfY2FjaGVfYmxvY2tfZGVhbGxvYyIsDQogICAgIm9jZnMyX2NvbW1pdF90cnVuY2F0ZSIs
DQogICAgIm9jZnMyX2ZyZWVfY2FjaGVkX2Jsb2NrcyIsDQogICAgIm9jZnMyX3RydW5jYXRlX2xv
Z19hcHBlbmQiLA0KICAgICJvY2ZzMl9yZW1vdmVfZXh0ZW50Ig0KICBdDQp9
--0000000000009f3bc0063bd2a6d5--
