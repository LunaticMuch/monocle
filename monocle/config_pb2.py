# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: monocle/config.proto
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database

# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(
    b'\n\x14monocle/config.proto\x12\x0emonocle_config"e\n\x11ProjectDefinition\x12\x0c\n\x04name\x18\x01 \x01(\t\x12\x18\n\x10repository_regex\x18\x02 \x01(\t\x12\x14\n\x0c\x62ranch_regex\x18\x03 \x01(\t\x12\x12\n\nfile_regex\x18\x04 \x01(\t"#\n\x12GetProjectsRequest\x12\r\n\x05index\x18\x01 \x01(\t"J\n\x13GetProjectsResponse\x12\x33\n\x08projects\x18\x01 \x03(\x0b\x32!.monocle_config.ProjectDefinition"\x19\n\tWorkspace\x12\x0c\n\x04name\x18\x01 \x01(\t"$\n\x14GetWorkspacesRequest\x12\x0c\n\x04void\x18\x01 \x01(\t"F\n\x15GetWorkspacesResponse\x12-\n\nworkspaces\x18\x01 \x03(\x0b\x32\x19.monocle_config.Workspace"\x82\x01\n\x05\x41\x62out\x12\x0f\n\x07version\x18\x01 \x01(\t\x12.\n\x05links\x18\x02 \x03(\x0b\x32\x1f.monocle_config.About.AboutLink\x1a\x38\n\tAboutLink\x12\x0c\n\x04name\x18\x01 \x01(\t\x12\x0b\n\x03url\x18\x02 \x01(\t\x12\x10\n\x08\x63\x61tegory\x18\x03 \x01(\t"\x1f\n\x0fGetAboutRequest\x12\x0c\n\x04void\x18\x01 \x01(\t"8\n\x10GetAboutResponse\x12$\n\x05\x61\x62out\x18\x01 \x01(\x0b\x32\x15.monocle_config.AboutB\x10Z\x0emonocle/configb\x06proto3'
)


_PROJECTDEFINITION = DESCRIPTOR.message_types_by_name["ProjectDefinition"]
_GETPROJECTSREQUEST = DESCRIPTOR.message_types_by_name["GetProjectsRequest"]
_GETPROJECTSRESPONSE = DESCRIPTOR.message_types_by_name["GetProjectsResponse"]
_WORKSPACE = DESCRIPTOR.message_types_by_name["Workspace"]
_GETWORKSPACESREQUEST = DESCRIPTOR.message_types_by_name["GetWorkspacesRequest"]
_GETWORKSPACESRESPONSE = DESCRIPTOR.message_types_by_name["GetWorkspacesResponse"]
_ABOUT = DESCRIPTOR.message_types_by_name["About"]
_ABOUT_ABOUTLINK = _ABOUT.nested_types_by_name["AboutLink"]
_GETABOUTREQUEST = DESCRIPTOR.message_types_by_name["GetAboutRequest"]
_GETABOUTRESPONSE = DESCRIPTOR.message_types_by_name["GetAboutResponse"]
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

About = _reflection.GeneratedProtocolMessageType(
    "About",
    (_message.Message,),
    {
        "AboutLink": _reflection.GeneratedProtocolMessageType(
            "AboutLink",
            (_message.Message,),
            {
                "DESCRIPTOR": _ABOUT_ABOUTLINK,
                "__module__": "monocle.config_pb2"
                # @@protoc_insertion_point(class_scope:monocle_config.About.AboutLink)
            },
        ),
        "DESCRIPTOR": _ABOUT,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.About)
    },
)
_sym_db.RegisterMessage(About)
_sym_db.RegisterMessage(About.AboutLink)

GetAboutRequest = _reflection.GeneratedProtocolMessageType(
    "GetAboutRequest",
    (_message.Message,),
    {
        "DESCRIPTOR": _GETABOUTREQUEST,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.GetAboutRequest)
    },
)
_sym_db.RegisterMessage(GetAboutRequest)

GetAboutResponse = _reflection.GeneratedProtocolMessageType(
    "GetAboutResponse",
    (_message.Message,),
    {
        "DESCRIPTOR": _GETABOUTRESPONSE,
        "__module__": "monocle.config_pb2"
        # @@protoc_insertion_point(class_scope:monocle_config.GetAboutResponse)
    },
)
_sym_db.RegisterMessage(GetAboutResponse)

if _descriptor._USE_C_DESCRIPTORS == False:

    DESCRIPTOR._options = None
    DESCRIPTOR._serialized_options = b"Z\016monocle/config"
    _PROJECTDEFINITION._serialized_start = 40
    _PROJECTDEFINITION._serialized_end = 141
    _GETPROJECTSREQUEST._serialized_start = 143
    _GETPROJECTSREQUEST._serialized_end = 178
    _GETPROJECTSRESPONSE._serialized_start = 180
    _GETPROJECTSRESPONSE._serialized_end = 254
    _WORKSPACE._serialized_start = 256
    _WORKSPACE._serialized_end = 281
    _GETWORKSPACESREQUEST._serialized_start = 283
    _GETWORKSPACESREQUEST._serialized_end = 319
    _GETWORKSPACESRESPONSE._serialized_start = 321
    _GETWORKSPACESRESPONSE._serialized_end = 391
    _ABOUT._serialized_start = 394
    _ABOUT._serialized_end = 524
    _ABOUT_ABOUTLINK._serialized_start = 468
    _ABOUT_ABOUTLINK._serialized_end = 524
    _GETABOUTREQUEST._serialized_start = 526
    _GETABOUTREQUEST._serialized_end = 557
    _GETABOUTRESPONSE._serialized_start = 559
    _GETABOUTRESPONSE._serialized_end = 615
# @@protoc_insertion_point(module_scope)
