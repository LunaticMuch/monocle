# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: monocle/config.proto
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database

# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


DESCRIPTOR = _descriptor.FileDescriptor(
    name="monocle/config.proto",
    package="monocle_config",
    syntax="proto3",
    serialized_options=b"Z\016monocle/config",
    create_key=_descriptor._internal_create_key,
    serialized_pb=b'\n\x14monocle/config.proto\x12\x0emonocle_config"e\n\x11ProjectDefinition\x12\x0c\n\x04name\x18\x01 \x01(\t\x12\x18\n\x10repository_regex\x18\x02 \x01(\t\x12\x14\n\x0c\x62ranch_regex\x18\x03 \x01(\t\x12\x12\n\nfile_regex\x18\x04 \x01(\t"#\n\x12GetProjectsRequest\x12\r\n\x05index\x18\x01 \x01(\t"J\n\x13GetProjectsResponse\x12\x33\n\x08projects\x18\x01 \x03(\x0b\x32!.monocle_config.ProjectDefinition"\x19\n\tWorkspace\x12\x0c\n\x04name\x18\x01 \x01(\t"$\n\x14GetWorkspacesRequest\x12\x0c\n\x04void\x18\x01 \x01(\t"F\n\x15GetWorkspacesResponse\x12-\n\nworkspaces\x18\x01 \x03(\x0b\x32\x19.monocle_config.WorkspaceB\x10Z\x0emonocle/configb\x06proto3',
)


_PROJECTDEFINITION = _descriptor.Descriptor(
    name="ProjectDefinition",
    full_name="monocle_config.ProjectDefinition",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="name",
            full_name="monocle_config.ProjectDefinition.name",
            index=0,
            number=1,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="repository_regex",
            full_name="monocle_config.ProjectDefinition.repository_regex",
            index=1,
            number=2,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="branch_regex",
            full_name="monocle_config.ProjectDefinition.branch_regex",
            index=2,
            number=3,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="file_regex",
            full_name="monocle_config.ProjectDefinition.file_regex",
            index=3,
            number=4,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=40,
    serialized_end=141,
)


_GETPROJECTSREQUEST = _descriptor.Descriptor(
    name="GetProjectsRequest",
    full_name="monocle_config.GetProjectsRequest",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="index",
            full_name="monocle_config.GetProjectsRequest.index",
            index=0,
            number=1,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=143,
    serialized_end=178,
)


_GETPROJECTSRESPONSE = _descriptor.Descriptor(
    name="GetProjectsResponse",
    full_name="monocle_config.GetProjectsResponse",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="projects",
            full_name="monocle_config.GetProjectsResponse.projects",
            index=0,
            number=1,
            type=11,
            cpp_type=10,
            label=3,
            has_default_value=False,
            default_value=[],
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=180,
    serialized_end=254,
)


_WORKSPACE = _descriptor.Descriptor(
    name="Workspace",
    full_name="monocle_config.Workspace",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="name",
            full_name="monocle_config.Workspace.name",
            index=0,
            number=1,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=256,
    serialized_end=281,
)


_GETWORKSPACESREQUEST = _descriptor.Descriptor(
    name="GetWorkspacesRequest",
    full_name="monocle_config.GetWorkspacesRequest",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="void",
            full_name="monocle_config.GetWorkspacesRequest.void",
            index=0,
            number=1,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=283,
    serialized_end=319,
)


_GETWORKSPACESRESPONSE = _descriptor.Descriptor(
    name="GetWorkspacesResponse",
    full_name="monocle_config.GetWorkspacesResponse",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="workspaces",
            full_name="monocle_config.GetWorkspacesResponse.workspaces",
            index=0,
            number=1,
            type=11,
            cpp_type=10,
            label=3,
            has_default_value=False,
            default_value=[],
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=321,
    serialized_end=391,
)

_GETPROJECTSRESPONSE.fields_by_name["projects"].message_type = _PROJECTDEFINITION
_GETWORKSPACESRESPONSE.fields_by_name["workspaces"].message_type = _WORKSPACE
DESCRIPTOR.message_types_by_name["ProjectDefinition"] = _PROJECTDEFINITION
DESCRIPTOR.message_types_by_name["GetProjectsRequest"] = _GETPROJECTSREQUEST
DESCRIPTOR.message_types_by_name["GetProjectsResponse"] = _GETPROJECTSRESPONSE
DESCRIPTOR.message_types_by_name["Workspace"] = _WORKSPACE
DESCRIPTOR.message_types_by_name["GetWorkspacesRequest"] = _GETWORKSPACESREQUEST
DESCRIPTOR.message_types_by_name["GetWorkspacesResponse"] = _GETWORKSPACESRESPONSE
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

ProjectDefinition = _reflection.GeneratedProtocolMessageType(
    "ProjectDefinition",
    (_message.Message,),
    {
        "DESCRIPTOR": _PROJECTDEFINITION,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.ProjectDefinition)
    },
)
_sym_db.RegisterMessage(ProjectDefinition)

GetProjectsRequest = _reflection.GeneratedProtocolMessageType(
    "GetProjectsRequest",
    (_message.Message,),
    {
        "DESCRIPTOR": _GETPROJECTSREQUEST,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.GetProjectsRequest)
    },
)
_sym_db.RegisterMessage(GetProjectsRequest)

GetProjectsResponse = _reflection.GeneratedProtocolMessageType(
    "GetProjectsResponse",
    (_message.Message,),
    {
        "DESCRIPTOR": _GETPROJECTSRESPONSE,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.GetProjectsResponse)
    },
)
_sym_db.RegisterMessage(GetProjectsResponse)

Workspace = _reflection.GeneratedProtocolMessageType(
    "Workspace",
    (_message.Message,),
    {
        "DESCRIPTOR": _WORKSPACE,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.Workspace)
    },
)
_sym_db.RegisterMessage(Workspace)

GetWorkspacesRequest = _reflection.GeneratedProtocolMessageType(
    "GetWorkspacesRequest",
    (_message.Message,),
    {
        "DESCRIPTOR": _GETWORKSPACESREQUEST,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.GetWorkspacesRequest)
    },
)
_sym_db.RegisterMessage(GetWorkspacesRequest)

GetWorkspacesResponse = _reflection.GeneratedProtocolMessageType(
    "GetWorkspacesResponse",
    (_message.Message,),
    {
        "DESCRIPTOR": _GETWORKSPACESRESPONSE,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.GetWorkspacesResponse)
    },
)
_sym_db.RegisterMessage(GetWorkspacesResponse)


DESCRIPTOR._options = None
# @@protoc_insertion_point(module_scope)
